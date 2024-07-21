<template>
  <div class="backwards">
    <div class="slide slide-1__background">
      <div class="slide-1__left-dashed-container">
        <img v-if="$matchMedia.xl" class="slide-1__left-dashed moveInRightDash duration--2" src="/images/left-dashed-desktop.svg" alt="">
      </div>
      <div class="slide-1__container">
        <div class="slide-1__first-block ">
          <h2 class="slide-1__heading moveInTop duration--1">
            Elevate <br>
            Your Career <br>
            with EXCEPTIONAL  <br>
            Projects.
          </h2>
          <div v-if="$matchMedia.xl" class="slide-1__ornament">
            <img class="slide-1__triangle fadeIn duration--2" src="https://i.ibb.co/5ngvTZq/Screenshot-2024-06-10-at-16-52-28.png" alt="">
          </div>
          <div v-else class="slide-1__ornament">
            <img class="slide-1__triangle fadeIn duration--2" src="https://i.ibb.co/5ngvTZq/Screenshot-2024-06-10-at-16-52-28.png" alt="">
            <img class="slide-1__left-dashed moveInRightDash duration--2" src="/images/left-dashed.svg" alt="">
            <img class="slide-1__right-dashed moveInBottomLeft duration--2" src="/images/right-dashed.svg" alt="">
          </div>
          <p class="slide-1__paragraph moveInTop duration--1_5">
            Elevate your career and enrich your Freelancer experience.
          </p>
          <router-link :to="{ name: 'explore' }" class="slide-1__button moveInTop duration--2 btn btn--yellow btn--large" tag="button">
            <span>Get Started</span>
            <span class="iconify" data-icon="ion:arrow-forward-outline" />
          </router-link>
        </div>
        <div class="slide-1__image-container moveInTop duration--2">
          <img class="slide-1__dot-1" src="" alt="">
          <img v-if="!$matchMedia.xl" class="slide-1__dot-2" src="" alt="">
          <img v-if="!$matchMedia.xl" class="slide-1__image" height="344" src="/images/smiling-woman-looking.png" alt="">
          <img v-else class="slide-1__image" src="/images/smiling-woman-looking-desktop.png" alt="">
        </div>
      </div>
      <div class="slide-1__right-dashed-container">
        <img class="slide-1__right-dashed moveInBottomLeft duration--2" src="/images/right-dashed-desktop.svg" alt="">
      </div>
    </div>
    <div class="slide slide-2__container">
      <div v-if="$matchMedia.xl" class="slide-2__left">
        <img class="slide-2__image" src="/images/slide-2.png" alt="">
      </div>
      <div class="slide-2__right">
        <h2 class="slide-2__heading">
          See The <br>
          Available <br>
          Projects on <br>
          The Platform
        </h2>
        <p class="slide-2__paragraph">
          Knowing the available projects that are currently posted on the website and the finished projects will determine your spirit!
        </p>
        <div class="slide-2__facts">
          <div class="slide-2__fact-item">
            <span class="iconify slide-2__fact--icon" data-icon="bx:bxs-brain" style="color: yellow;" />
            <div class="slide-2__fact--number">
              {{ projectByStatusCount.hiring }}
            </div>
            <div class="slide-2__fact--name">
              Active Projects
            </div>
          </div>
          <div class="slide-2__fact-item">
            <span class="iconify slide-2__fact--icon" data-icon="entypo:paper-plane" style="color: yellow;" />
            <div class="slide-2__fact--number">
              {{ projectByStatusCount.ongoing }}
            </div>
            <div class="slide-2__fact--name">
              Ongoing Projects
            </div>
          </div>
          <div class="slide-2__fact-item">
            <span class="iconify slide-2__fact--icon" data-icon="ant-design:check-circle-outlined" style="color: yellow;" />
            <div class="slide-2__fact--number">
              {{ projectByStatusCount.finished }}
            </div>
            <div class="slide-2__fact--name">
              Finished Projects
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="slide slide-3__container">
      <h2 class="slide-3__heading">
        Leaderboard
      </h2>
      <p class="slide-3__paragraph">
        These are the highest achievers. Set them as examples, or beat their records. The choice is yours!
      </p>
      <div v-if="!$matchMedia.xl">
        <TopBoardList :arrow="false" :data="topLeaderboards" />
      </div>
      <div v-else>
        <TopBoardList :differ="false" :arrow="false" :show-all="true" :data="topLeaderboards" />
      </div>
      <router-link :to="{ name: 'leaderboard' }" class="btn btn--blue btn--large slide-3__button mt-1" tag="button">
        See All Leaderboard
      </router-link>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { mapGetters } from 'vuex'
import TopBoardList from '~/components/TopBoardList'

export default {
  name: 'HomePage',

  middleware: ['newcomer'],
  components: { TopBoardList },

  metaInfo () {
    return {
      title: 'Home',
      meta: [
        { name: 'description', content: 'workfusion: Freelancer Platform for Students. Expand your career by doing projects.' }
      ]
    }
  },

  data: () => ({
    projectByStatusCount: {},
    topLeaderboards: {},
    debouncedScroll: ''
  }),

  computed: {
    ...mapGetters({
      authenticated: 'auth/check',
      snackbar: 'notification/snackbar'
    })
  },

  mounted () {
    this.appendNavBg()
    this.getHomeData()

    this.$nextTick(() => {
      document.querySelector('.desktop-nav', '.nav-base').style.boxShadow = 'unset'
      let app = document.querySelector('html')
      window.onscroll = () => {
        clearTimeout(this.debouncedScroll)
        this.debouncedScroll = setTimeout(() => {
          if (app.scrollTop > 0) {
            document.querySelector('.desktop-nav', '.nav-base').style.boxShadow = '0 0.2rem 0.4rem 0 rgba(0, 0, 0, 0.1)'
          } else {
            document.querySelector('.desktop-nav', '.nav-base').style.boxShadow = 'unset'
          }
        }, 50)
      }
    })
  },

  beforeDestroy () {
    this.removeNavBg()
    window.onscroll = null
    document.querySelector('.desktop-nav', '.nav-base').style.boxShadow = '0 0.2rem 0.4rem 0 rgba(0, 0, 0, 0.1)'
  },

  methods: {
    appendNavBg () {
      let sheet = document.createElement('style')
      sheet.setAttribute('id', 'tempNavBg')
      sheet.innerHTML = '.nav-base { background: #F2F4F6 } .desktop-nav { background: #F2F4F6 }'
      document.body.appendChild(sheet)
    },

    removeNavBg () {
      const sheetToBeRemoved = document.getElementById('tempNavBg')
      let sheetParent = sheetToBeRemoved.parentNode
      sheetParent.removeChild(sheetToBeRemoved)
    },

    async getHomeData () {
      try {
        const { data } = await axios.get(`/api/home`)
        this.projectByStatusCount = data.project_count || {}
        this.topLeaderboards = data.top_boards || {}
      } catch (error) {
        console.error('Error fetching home data:', error)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import './resources/sass/abstract/_mixins.scss';

.backwards {
  margin: -6rem -3rem -3rem;

  @include respon(xl) {
    margin-block-start: calc(-1 * var(--desktop-nav-height));
  }

  .slide-1__button {
    background-color: yellow;
    color: black;
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 0.25rem;
    transition: background-color 0.3s ease;
    cursor: pointer;

    &:hover {
      background-color: #ffd700; // Brighten the yellow on hover
    }
  }

  .slide  .slide-1__paragraph {
    color: #333; // Adjusting text color for better readability
    margin-block-start: 1rem; // Adding spacing between elements
  }

  .slide-2__fact-item {
    margin-block-end: 1rem; // Adding spacing between project status items
  }

  .slide-2__fact--icon {
    font-size: 1.5rem; // Increasing icon size for better visibility
    margin-inline-end: 0.5rem; // Adding spacing between icon and number
  }

  .slide-3__heading {
    color: #333; // Adjusting text color for better readability
  }

  .slide-3__paragraph {
    color: #666; // Adjusting text color for better readability
    margin-block-start: 1rem; // Adding spacing between elements
  }

  .slide-3__button {
    background-color: yellow; // Setting yellow background for the button
    color: black; // Setting black text color for better contrast
    padding: 0.5rem 1rem; // Adding padding to the button
    border: none; // Removing border
    border-radius: 0.25rem; // Adding border radius
    transition: background-color 0.3s ease; // Smooth transition for background color change
    cursor: pointer; // Changing cursor to pointer on hover

    &:hover {
      background-color: #ffd700; // Brighten the yellow on hover
    }
  }

  .slide-1__left-dashed-container,
  .slide-1__right-dashed-container {
    position: absolute;
    inset-block-start: 0;
    inline-size: 50%;
    block-size: 100%;
    overflow: hidden;
  }

  .slide-1__left-dashed-container {
    inset-inline-start: 0;
  }

  .slide-1__right-dashed-container {
    inset-inline-end: 0;
  }

  .slide-1__left-dashed,
  .slide-1__right-dashed {
    position: absolute;
    inset-block-end: 0;
    inline-size: 100%;
    height: auto;
  }

  .slide-1__left-dashed {
    left: 0;
  }

  .slide-1__right-dashed {
    right: 0;
  }

  .slide-1__container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem;
    width: 100%;
    height: 100%;
  }

  .slide-1__first-block {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    width: 50%;
  }

  .slide-1__heading {
    font-size: 2.5rem;
    font-weight: bold;
    line-height: 1.2;
    color: #333;
    margin-bottom: 1rem;
  }

  .slide-1__paragraph {
    font-size: 1.2rem;
    line-height: 1.5;
    color: #333;
    margin-bottom: 2rem;
  }

  .slide-1__ornament {
    position: relative;
    width: 100%;
    height: auto;
    margin-bottom: 2rem;
  }

  .slide-1__triangle {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 100%;
    height: auto;
  }

  .slide-1__image-container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-end;
    width: 50%;
  }

  .slide-1__image {
    width: 100%;
    height: auto;
  }

  .slide-1__dot-1,
  .slide-1__dot-2 {
    position: absolute;
    width: 100%;
    height: auto;
  }

  .slide-1__dot-1 {
    top: 10%;
    left: 10%;
  }

  .slide-1__dot-2 {
    bottom: 10%;
    right: 10%;
  }

  .slide-2__container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem;
    width: 100%;
    height: 100%;
  }

  .slide-2__left {
    width: 50%;
  }

  .slide-2__right {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    width: 50%;
  }

  .slide-2__image {
    width: 100%;
    height: auto;
  }

  .slide-2__heading {
    font-size: 2rem;
    font-weight: bold;
    line-height: 1.2;
    color: #333;
    margin-bottom: 1rem;
  }

  .slide-2__paragraph {
    font-size: 1.1rem;
    line-height: 1.5;
    color: #333;
    margin-bottom: 2rem;
  }

  .slide-2__facts {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    width: 100%;
  }

  .slide-2__fact-item {
    display: flex;
    align-items: center;
    margin-bottom: 1rem;
  }

  .slide-2__fact--icon {
    font-size: 1.5rem;
    margin-right: 0.5rem;
  }

  .slide-2__fact--number {
    font-size: 1.5rem;
    font-weight: bold;
    color: #333;
    margin-right: 0.5rem;
  }

  .slide-2__fact--name {
    font-size: 1rem;
    color: #333;
  }

  .slide-3__container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 2rem;
    width: 100%;
    height: 100%;
  }

  .slide-3__heading {
    font-size: 2rem;
    font-weight: bold;
    line-height: 1.2;
    color: #333;
    margin-bottom: 1rem;
  }

  .slide-3__paragraph {
    font-size: 1.1rem;
    line-height: 1.5;
    color: #666;
    margin-block-end: 2rem;
  }

  .slide-3__button {
    background-color: yellow;
