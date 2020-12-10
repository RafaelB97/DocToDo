<template>
  <div class="side">
    <div class="sideContainer">
      <!-- {{ board.invitations }} -->
      <hr>
      <ul>
        <li v-for="invitation in board.invitations" :key="invitation.id">
          <p>{{ invitation.user.email }}</p>
          <svg @click="deleteInvitation(invitation.id)" width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-trash" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
            <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
            <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4L4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
          </svg>
        </li>
      </ul>
      <input v-model="name" class="form-control">
      <button @click="addUser" class="btn">Add User</button>
    </div>
  </div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: ['board'],
  data: function() {
    return {
      name: ""
    }
  },

  methods: {
    addUser: function() {
      const data = new FormData()
      data.append("invitation[email]", this.name)
      data.append("invitation[group_id]", this.board.id)
      Rails.ajax({
        url: "/invitations/addUser",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          console.log("Finish!")
          console.log(data)
          this.board.invitations.push(data)
        },
        error: (data) => {
          console.log(data)
        }
      })
    },

    deleteInvitation: function(id) {
      Rails.ajax({
        url: `/invitations/${id}`,
        type: "DELETE",
        success: (data) => {
          this.board.invitations = this.board.invitations.filter((invitation) => invitation.id !== id)
        },
        error: (data) => {
          console.log(data)
        }
      })

    }
  }
}
</script>

<style scoped>

.side {
  /* width: 20vw; */
  width: 25%;
  background-color: lightgray;
}

.sideContainer {
  margin: 10px;
}

li {
  display: flex;
}

</style>