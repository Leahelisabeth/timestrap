<client>
    <div class="row mb-2 bg-faded">
        <virtual if={ edit }>
            <input type="text"
                   class="form-control rounded-0 border-0 bg-faded col-10"
                   ref="name"
                   value={ name }/>
            <button class="btn btn-success col-2 rounded-0"
                    onclick={ saveClient }>
                Save
            </button>
        </virtual>
        <virtual if={ !edit }>
            <div class="col-6 d-flex align-items-center">
                <a class="text-primary font-weight-bold" onclick={ showProjects }>
                    <i class="fa fa-chevron-circle-{ chevron }" aria-hidden="true"></i> { name }
                </a>
            </div>
            <div class="col-2 d-flex align-items-center">
                <i class="fa fa-clock-o small text-muted text-uppercase mr-2" aria-hidden="true"></i>
                <span class="mb-1">{ total_duration }</span>
            </div>
            <div class="col-2 d-flex align-items-center">
                <i class="fa fa-list small text-muted text-uppercase mr-2" aria-hidden="true"></i>
                <span class="mb-1">{ total_projects }</span>
            </div>
            <button class="btn btn-warning col-2 rounded-0" onclick={ editClient }>
                Edit
            </button>
        </virtual>
    </div>

    <form onsubmit={ submitProject } if={ productsShown }>
        <div class="row mb-1">
            <input type="text"
                   class="form-control form-control-sm rounded-0 border-0 col-10"
                   ref="project_name"
                   placeholder="New Project Name"
                   required/>
            <button type="submit" class="btn btn-success btn-sm col-2 rounded-0">
                Add
            </button>
        </div>
    </form>

    <div class="mb-2">
        <project class="row mb-1 bg-faded"
                 each={ projects }
                 data-is="project"
                 if={ productsShown }/>
    </div>


    <script>
        editClient(e) {
            this.edit = true
            this.update()
        }


        showProjects(e) {
            this.productsShown = !this.productsShown
            if (this.chevron === 'down') {
                this.chevron = 'up'
            } else {
                this.chevron = 'down'
            }
            this.update()
        }


        saveClient(e) {
            e.preventDefault()
            this.name = this.refs.name.value
            quickFetch(this.url, 'put', this).then(function(data) {
                this.name.value = ''
                this.edit = false
                this.update()
            }.bind(this));
        }


        submitProject(e) {
            e.preventDefault()
            let body = {
                name: this.refs.project_name.value,
                client: this.url
            }
            quickFetch(projectsApiUrl, 'post', body).then(function(data) {
                this.refs.project_name.value = ''
                this.projects.unshift(data)
                this.update()
            }.bind(this));
        }

        this.on('mount', function() {
            this.chevron = 'down'
            this.update()
        }.bind(this))
    </script>
</client>
