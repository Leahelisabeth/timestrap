<project>
    <virtual if={ edit }>
        <input type="text"
               class="form-control form-control-sm col-10 rounded-0 border-0"
               ref="name"
               value={ name }>
        <button class="btn btn-success btn-sm col-2 rounded-0 border-0"
                onclick={ saveProject }>
            Save
        </button>
    </virtual>
    <virtual if={ !edit }>
        <a class="text-primary col-6" onclick={ goToEntries }>
            { name }
        </a>
        <div class="col-2 d-flex align-items-center">
            <i class="fa fa-clock-o small text-muted text-uppercase mr-2" aria-hidden="true"></i>
            <span class="mb-1">{ total_duration }</span>
        </div>
        <div class="col-2 d-flex align-items-center">
            <i class="fa fa-list small text-muted text-uppercase mr-2" aria-hidden="true"></i>
            <span class="mb-1">{ total_entries }</span>
        </div>
        <button class="btn btn-warning btn-sm col-2 rounded-0 border-0"
                onclick={ editProject }>
            Edit
        </button>
    </virtual>


    <script>
        editProject(e) {
            this.edit = true;
            this.update();
        }


        goToEntries(e) {
            let query = {
                project: e.item.id
            }
            document.location.href = entriesUrl + '?' + $.param(query);
        }


        saveProject(e) {
            e.preventDefault();
            this.name = this.refs.name.value;
            quickFetch(this.url, 'put', this).then(function(data) {
                this.name.value = '';
                this.edit = false;
                this.update();
            }.bind(this));
        }
    </script>
</project>
