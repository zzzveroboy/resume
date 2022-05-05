<template>
  <div class="container">
    <div class="control">
      <div class="button" @click="loginVK">Login</div>
    </div>

    <div class="responses">
      <div>accessToken: {{ accessToken }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OpenApi',

  data() {
    return {
      accessToken: null,
      changedCookie: false,
      cookie: '',
      interval: null
    };
  },

  computed: {
    authorizeUrl() {
      const params = {
        client_id: 8152845,
        display: 'popup',
        redirect_uri: 'http://localhost:8080/authVk.html',
        scope: 'groups',
        response_type: 'token'
      };

      return `https://oauth.vk.com/authorize?client_id=${params.client_id}&display=${params.display}&redirect_uri=${params.redirect_uri}&scope=${params.scope}&response_type=${params.response_type}&v=5.131`;
    }
  },
  
  watch: {
    changedCookie(value) {
      if (value) {
        clearInterval(this.interval);
        console.log('Interval Stop');
      }
    }
  },

  created() {
    this.cookie = document.cookie;
  },

  methods: {
    loginVK() {
      const popup = window.open('http://localhost:8080/authVk.html', '_blank', 'popup=1');
      
      setTimeout(() => {
        popup.postMessage({ source: 'vk_api', url: this.authorizeUrl });

        this.interval = setInterval(this.checkCookie, 500);
        console.log('Interval Start');
      }, 1000);
    },

    checkCookie() {
      console.log('checkCookie');
      const newCookie = document.cookie;

      if (newCookie != this.cookie) {
          this.changedCookie = true;
          console.log('Cookie changed');
          this.accessToken = this.getCookie('vk_api_code');
        }
    },

    getCookie(name) {
      let matches = document.cookie.match(new RegExp(
        "(?:^|; )" + name.replace(/([.$?*|{}()[]\/+^])/g, '\\$1') + "=([^;]*)"
      ));
      return matches ? decodeURIComponent(matches[1]) : undefined;
    }
  }
}
</script>

<style>
.container {
  display: flex;
}

.profile {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.profile > img {
  height: 50px;
  width: 50px;
  border-radius: 50%;
  margin-bottom: 15px;
}

.groups {
  display: flex;
  align-items: flex-start;
  flex-wrap: wrap;
  margin-left: 30px;
}

.groups > .group {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: #999;
  border: 2px solid #000;
  padding: 10px;
  color: #fff;
}

.groups > .group > img {
  margin-bottom: 10px;
  border-radius: 50%;
}

.control {
  background: #eee;
  display: flex;
  flex-direction: column;
  padding: 10px;
  width: 200px;
  height: 500px;
  border: 2px solid gray;
}

.button {
  background: blueviolet;
  color: white;
  padding: 10px 20px;
  margin-bottom: 10px;
  font-size: 1.5rem;
  display: inline-block;
  border-radius: 0.5rem;
  cursor: pointer;
}
</style>