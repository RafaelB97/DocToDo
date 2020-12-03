<template>
  <div id="app">
    <p>{{ original_board.name }}</p>
    <!-- <p>{{ original_board.lists }}</p> -->

    <draggable v-model="board.lists" group="lists" class="row dragArea" handle=".handle" @update="listMoved">
      <list v-for="list in board.lists" :key="list.id" :list="list"></list>
    </draggable>

    <div class="card card-body">
      <a v-if="!editing" @click="startEditing">Add a list</a>
      <textarea v-if="editing" v-model="message" ref="message" class="form-control"></textarea>
      <button v-if="editing" @click="submitList" class="btn btn-secondary">Add</button>
      <a v-if="editing" @click="editing=false">Cancel</a>
    </div>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  components: { draggable, list },

  props: ['original_board'],

  data: function () {
    return {
      board: this.original_board,
      editing: false,
      message: "",
    }
  },

  methods: {
    listMoved: function(event) {
      console.log(event)
      var data = new FormData
      data.append("list[position]", event.newIndex + 1)

      Rails.ajax({
        url: `/lists/${this.board.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    },

    startEditing: function() {
      this.editing = true
      this.$nextTick(() => this.$refs.message.focus())
    },

    submitList: function() {
      var data = new FormData
      data.append("list[group_id]", window.store.board.id)
      data.append("list[name]", this.message)

      Rails.ajax({
        url: "/lists",
        type: "POST",
        data: data,
        dataType: "json",
        success: data => {
          window.store.board.lists.push(data)
          this.message = ""
          this.editing = false
        }
      })
    },
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

.dragArea {
  min-height: 10px;
}

.list {
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  margin-right: 20px;
  padding: 10px;
  vertical-align: top;
  width: 270px;
}
</style>
