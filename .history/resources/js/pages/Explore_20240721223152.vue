<template>
  <div class="explore-container">
    <header class="explore-header">
      <h1 class="explore-title">
        Explore Projects
      </h1>

      <div class="explore-search">
        <div class="search-form">
          <input
            v-if="$matchMedia.xl" v-model="query" type="search"
            class="search-input"
            placeholder="Search Projects"
            @keyup.enter="search"
          >
          <input
            v-else v-model="query" type="search"
            class="search-input"
            placeholder="Explore Projects" @change="search"
          >
          <label for="search-input" class="search-icon">
            <span class="iconify" data-icon="ic:round-search" width="30" height="30" />
          </label>
        </div>
        <button v-if="$matchMedia.xl" v-debounce:600ms="search" :debounce-events="'click'" class="search-button" :disabled="query.length === 0">
          Explore
        </button>
      </div>
    </header>

    <section class="explore-main">
      <h2 class="main-title">
        Available Projects
      </h2>
      <button class="filter-toggle" @click="toggleFilter">
        <div class="filter-icon">
          <span class="iconify" data-icon="ic:round-filter-list" height="24" width="24" />
          <span v-if="$matchMedia.xl">Filters</span>
        </div>
      </button>
    </section>

    <Modal v-if="!$matchMedia.xl" ref="filtersModal" :type="`small`">
      <template v-slot:header>
        <h4 class="modal-header">
          Filters
        </h4>
      </template>

      <template v-slot:body>
        <div class="modal-separator" />

        <div class="filter-select">
          <select v-model="filters.selected.status" @change="filterProjects">
            <option disabled value="">
              Status Project:
            </option>
            <option v-for="status in filters.statuses" :key="`status-${status.name}`">
              {{ status.name }}
            </option>
          </select>
        </div>

        <div class="filter-checkbox-group">
          <label v-for="expertise in filters.expertises" :key="`expertise-${expertise.name}`" class="checkbox-label">
            {{ expertise.name }}
            <input v-model="expertise.isChecked" type="checkbox" @change="filterProjects">
            <span class="checkbox-checkmark"></span>
            <p class="checkbox-count">({{ expertise.count }})</p>
          </label>
        </div>

        <div class="filter-select">
          <select v-model="filters.selected.reward" @change="filterProjects">
            <option disabled value="">
              Rewards:
            </option>
            <option v-for="reward in filters.rewards" :key="`reward-${reward.name}`">
              {{ reward.name }}
            </option>
          </select>
        </div>
      </template>

      <template v-slot:footer>
        <button class="clear-filter-button" @click="clearFilter">
          Clear Filter
        </button>
      </template>
    </Modal>

    <div v-show="showFilter && $matchMedia.xl" class="filter-container">
      <div class="filter-options">
        <div class="filter-select">
          <select v-model="filters.selected.status" @change="filterProjects">
            <option disabled value="">
              Status Project:
            </option>
            <option v-for="status in filters.statuses" :key="`status-${status.name}`">
              {{ status.name }}
            </option>
          </select>
        </div>
        <div class="filter-checkbox-group">
          <div v-for="expertise in filters.expertises" :key="`expertise-${expertise.name}`" class="checkbox-container">
            <input :id="`expertise-${expertise.name}`" v-model="expertise.isChecked" type="checkbox" @change="filterProjects">
            <label :for="`expertise-${expertise.name}`" class="checkbox-label">{{ expertise.name }}</label>
          </div>
        </div>
        <div class="filter-select">
          <select v-model="filters.selected.reward" @change="filterProjects">
            <option disabled value="">
              Rewards:
            </option>
            <option v-for="reward in filters.rewards" :key="`reward-${reward.name}`">
              {{ reward.name }}
            </option>
          </select>
        </div>
      </div>
    </div>

    <div class="project-list">
      <template v-if="loading">
        <content-placeholders
          v-for="i in 9"
          :key="`placeholder-${i}`"
          class="placeholders-container"
          :rounded="true"
        >
          <content-placeholders-img />
          <content-placeholders-heading />
        </content-placeholders>
      </template>
      <ProjectCard v-for="(project) in projects" :key="`project-${project.id}`" :data="project" />
      <p v-if="!loading && projects.length === 0" class="no-projects-message">
        No projects match your criteria
      </p>
    </div>

    <button v-if="canLoadMore && projects.length !== 0" class="load-more-button" @click="loadMore">
      <span>Load More</span><span v-if="$matchMedia.xl"> Projects</span>
    </button>
  </div>
</template>

<script>
import axios from 'axios'
import ProjectCard from '~/components/ProjectCard'

export default {
  name: 'ExplorePage',

  components: { ProjectCard },

  metaInfo () {
    return {
      title: 'Explore',
      meta: [
        { name: 'description', content: 'workfusion Explore: Search the latest posted projects for you to apply or peek up the best projects that have been finished.' }
      ]
    }
  },

  data: () => {
    return {
      loadMoreType: 'auto',
      debounceAutoMore: '',
      loading: true,
      beforeFilterProjects: [],
      projects: [],
      query: '',
      page: 1,
      canLoadMore: true,
      showFilter: false,
      filters: {
        expertises: [
          { name: 'UI/UX Designer', isChecked: false, count: 0, apiName: 'ui_ux_designer' },
          { name: 'Frontend Engineer', isChecked: false, count: 0, apiName: 'front_end_engineer' },
          { name: 'Backend Engineer', isChecked: false, count: 0, apiName: 'back_end_engineer' },
          { name: 'Data Expert', isChecked: false, count: 0, apiName: 'data_expert' }
        ],
        applicantTypes: [
          { name: 'Individual', count: 0, apiName: 'applicant_type' },
          { name: 'Team', count: 0, apiName: 'applicant_type' },
          { name: 'Individual & Team', count: 0, apiName: 'applicant_type' }
        ],
        rewards: [
          { name: 'Salary & Certificate', icount: 0 },
          { name: 'Certificate', count: 0, apiName: 'certificate' },
          { name: 'Salary', icount: 0, apiName: 'salary' }
        ],
        statuses: [
          { name: 'Hiring', count: 0 },
          { name: 'Ongoing', count: 0 },
          { name: 'Finished', count: 0 }
        ],
        selected: {
          applicantType: '',
          reward: '',
          status: ''
        }
      }
    }
  },

  mounted () {
    if (this.$route.query.query) {
      this.query = this.$route.query.query
      this.searchQuery()
    } else this.getAll()

    if (this.loadMoreType === 'auto') {
      let app = document.querySelector('html')
      this.debounceAutoMore = ''
      window.onscroll = () => {
        clearTimeout(this.debounceAutoMore)
        this.debounceAutoMore = setTimeout(() => {
          let nearBottom = app.scrollTop + 1200 > app.scrollHeight
          if (nearBottom && this.canLoadMore) this.loadMore()
        }, 300)
      }
    }
  },

  beforeDestroy () {
    window.onscroll = null
    clearTimeout(this.debounceAutoMore)
  },

  methods: {
    async search () {
      if (this.query !== this.$route.query.search) {
        this.$router.push({ name: 'explore', query: { search: this.query } })
        this.page = 1
        this.searchQuery()
      }
    },

    async searchQuery () {
      await axios.get('/api/projects/search?page=' + this.page, {
        params: { query: this.query }
      })
      .then(response => {
        this.loading = false
        this.beforeFilterProjects = response.data.data
        this.orderProjects()
        this.projects = this.beforeFilterProjects
        this.page++
        this.filterProjects()
        this.canLoadMore = response.data.next_page_url !== null
      })
    },

    async get