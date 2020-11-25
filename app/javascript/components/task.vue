<template>
  <div>
    <div @click='editing=true' class="card card-body">
      {{ task.name }}
    </div>

    <div v-if='editing' class='modal-backdrop show'></div>

    <div v-if='editing' @click='closeModal' class='modal show' style='display: block'>
      <div class='modal-dialog'>
        <div class="modal-content">
          <div class="modal-header">
            <h5 class='modal-title'>{{ task.name }}</h5>
          </div>
          <div class="modal-body">
            <input v-model='name' class='form-control'>
          </div>
          <div class="modal-footer">
            <button @click='save' type='button' class='btn btn-primary'>Save changes</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: ['task', 'list'],
  data: function() {
    return {
      editing: false,
      name: this.task.name
    }
  },

  methods: {
    closeModal: function(event) {
      if (event.target.classList.contains('modal')) { this.editing = false }
    },
    save: function() {
      var data = new FormData
      data.append('task[name]', this.name)

      Rails.ajax({
        url: `/tasks/${this.task.id}`,
        type: "PATCH",
        data: data,
        dataType: "json",
        success: data => {
          const list_index = window.store.board.lists.findIndex((item) => item.id === this.list.id)
          const task_index = window.store.board.lists[list_index].tasks.findIndex((item) => item.id === this.task.id)
          window.store.board.lists[list_index].tasks.splice(task_index, 1, data)

          this.editing = false
        }
      })
    }
  }
}
</script>

<style>

</style>