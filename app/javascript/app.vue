<template>
  <div id="app">
    <groupbar :board="original_board"></groupbar>
    <!-- <p>{{ original_board.lists }}</p> -->

    <draggable v-model="board.lists" group="lists" class="row dragArea" handle=".handle" @update="listMoved">
      <list v-for="list in board.lists" :key="list.id" :list="list"></list>
    </draggable>

    <div class="addContainer">
      <div class="card card-body addArea">
        <a v-if="!editing" @click="startEditing">
          <svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-plus-circle" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
            <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
          </svg> Add List
        </a>
        <textarea v-if="editing" v-model="message" ref="message" class="form-control"></textarea>
        <button v-if="editing" @click="submitList" class="btn btn-secondary">Add</button>
        <a v-if="editing" @click="editing=false">Cancel</a>
      </div>
    </div>

  </div>
</template>

<script>
import Rails from '@rails/ujs';
import draggable from 'vuedraggable'
import list from 'components/list'
import groupbar from 'components/groupbar'

export default {
  components: { draggable, list, groupbar },

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
.dragArea {
  margin: 10px;
  min-height: 10px;
  display: grid;
  grid-auto-columns: 272px;
  grid-auto-flow: column;
  grid-gap: 15px;
  overflow-x: auto;
}

.addContainer {
  display: flex;
  justify-content: center;
}

.addArea {
  text-align: center;
  flex-basis: 25%;
  flex-grow: 0;
  flex-shrink: 0;
}
</style>
