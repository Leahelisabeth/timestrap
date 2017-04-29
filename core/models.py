# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from datetime import date

from django.db import models
from django.db.models import Sum

from .utils import duration_string


class Client(models.Model):
    name = models.CharField(max_length=255)
    archive = models.BooleanField(default=False)

    class Meta:
        ordering = ['-id']

    def __str__(self):
        return 'Client: ' + self.name

    def get_total_projects(self):
        return self.projects.count()

    def get_total_duration(self):
        return duration_string(self.projects.aggregate(
                Sum('entries__duration')
        )['entries__duration__sum'])


class Project(models.Model):
    client = models.ForeignKey('Client', related_name='projects')
    name = models.CharField(max_length=255)
    archive = models.BooleanField(default=False)

    class Meta:
        ordering = ['client', '-id']

    def __str__(self):
        return 'Project: ' + self.name

    def get_total_entries(self):
        return self.entries.count()

    def get_total_duration(self):
        return duration_string(self.entries.aggregate(
            Sum('duration')
        )['duration__sum'])


class Entry(models.Model):
    project = models.ForeignKey('Project', related_name='entries')
    user = models.ForeignKey('auth.User', related_name='entries')
    date = models.DateField(blank=True)  # TODO: Swap to datetime field
    duration = models.DurationField(blank=True)
    note = models.TextField(blank=True, null=True)

    class Meta:
        ordering = ['-date', '-id']
        verbose_name_plural = 'Entries'

    def save(self, *args, **kwargs):
        if not self.date:
            self.date = date.today()
        super(Entry, self).save(*args, **kwargs)

    def __str__(self):
        return 'Entry for ' + self.project.name + ' by ' + self.user.username
