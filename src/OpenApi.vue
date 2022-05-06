<template>
  <div class="container">
    <div class="control">
      <div class="button" @click="loginVK">Login</div>
      <div class="button" @click="logoutVK">Logout</div>

      <div v-if="profile" class="profile">
        <h3>Аккаунт</h3>
        <img :src="profile.photo_50" />
        <span>Имя: {{ profile.first_name }}</span>
        <span>Фамилия: {{ profile.last_name }}</span>
      </div>
    </div>

    <div class="responses">
      <h1>code: {{ code }}</h1>
      <div class="groups">
        <div v-for="(group, index) in groups" :key="index" class="group">
          <img :src="group['photo_50']" alt="">
          <span>{{ group.name }}</span>
          <span>id: {{ group.id }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OpenApi',

  data() {
    return {
      changedCookie: false,
      interval: null,
      code: null,
      codeInCookie: '',
      groups: [],
      profile: null
    };
  },

  computed: {
    authorizeUrl() {
      const params = {
        client_id: 8152845,
        display: 'popup',
        redirect_uri: 'https://webmacaque.ru/authVk.html',
        scope: 'stories,photos,messages,docs,manage',
        group_ids: this.groups.map(({ id }) => id).join(),
        response_type: 'code'
      };

      return `https://oauth.vk.com/authorize?client_id=${params.client_id}&display=${params.display}&redirect_uri=${params.redirect_uri}&scope=${params.scope}&group_ids=${params.group_ids}&response_type=${params.response_type}&v=5.131`;
    }
  },
  
  watch: {
    changedCookie(value) {
      if (value) {
        clearInterval(this.interval);
        this.changedCookie = false;
        console.log('Interval Stop');
      }
    }
  },

  created() {
    this.codeInCookie = this.getCookie('vk_api_code');
  },

  mounted() {
    this.initVK();
  },

  methods: {    
    // Инициализация
    initVK() {
      var element = document.createElement('script');
      element.src = 'https://vk.com/js/api/openapi.js?169';
      element.onload = () => {
        window.VK.init({
          apiId: 8152845
        });
      }
      document.head.appendChild(element);

      setTimeout(() => {
        window.VK.Auth.getLoginStatus((response) => {
          console.log('VK.Auth.getLoginStatus', response);
          if (response.session) {
            this.getData(response);
            this.getCode();
          }
        });
      }, 1000);
    },
    
    // Авторизация
    loginVK() {
      window.VK.Auth.login((response) => {
        console.log('VK.Auth.login', response);
        if (response.session) {
          console.log('Пользователь успешно авторизовался', response);
          this.getData(response);
          this.getCode();
        } else {
          console.log('Пользователь нажал кнопку Отмена в окне авторизации');
        }
      }, 327680);
    },

    logoutVK() {
      window.VK.Auth.logout();
      this.code = null;
      this.codeInCookie = '';
      this.groups = [];
      this.profile = null;
    },

    // Получение данных аккаунта и его сообществ
    getData(response) {
      this.profile = response.session.user;

      window.VK.Api.call('groups.get', { filter: 'admin', extended: true, v: '5.131' }, (response) => {
        console.log('VK.Api.call(groups.get)', response);
        this.groups = response.response.items;
      });

      window.VK.Api.call('users.get', { fields: 'photo_50', v: '5.131' }, (response) => {
        console.log('VK.Api.call(users.get)', response);
        this.profile = response.response[0]
      });
    },

    // Получение ключа доступа сообщества
    getCode() {
      var width = 665,
          height = 370,
          left = (screen.width/2)-(width/2),
          top = (screen.height/2)-(height/2),
          features = `width=${width},height=${height},left=${left},top=${top}`;

      const popup = open('https://webmacaque.ru/authVk.html', '_blank', `popup=1,${features}`);

      setTimeout(() => {
        popup.postMessage({ source: 'vk_api', url: this.authorizeUrl });

        this.interval = setInterval(this.checkCookie, 500);
        console.log('Interval Start');
      }, 1000);
    },

    // Метод для отслеживания изменений в Cookie
    checkCookie() {
      console.log('checkCookie');
      const newCookie = this.getCookie('vk_api_code');

      if (newCookie != this.codeInCookie) {
          this.changedCookie = true;
          this.code = this.getCookie('vk_api_code');
          this.codeInCookie = this.code;
        }
    },

    // Получение конкретного Cookie
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