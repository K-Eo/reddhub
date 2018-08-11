class GoogleAnalytics {
  static load() {
    // Google Analytics depends on a global _gaq array. window is the global scope.
    window._gaq = []
    window._gaq.push(['_setAccount', GoogleAnalytics.analyticsId()])

    // Create a script element and insert it in the DOM
    const ga = document.createElement("script")
    ga.type = "text/javascript"
    ga.async = true
    
    if (document.location.protocol === 'https:') {
      ga.src = 'https://ssl.google-analytics.com/ga.js'
    } else {
      ga.src = 'http://www.google-analytics.com/ga.js'
    }

    const firstScript = document.getElementsByTagName("script")[0]
    firstScript.parentNode.insertBefore(ga, firstScript)

    // If Turbolinks is supported, set up a callback to track pageviews on page:change.
    // If it isn't supported, just track the pageview now.
    if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
      document.addEventListener('page:change', () => GoogleAnalytics.trackPageview(), true)
    } else {
      GoogleAnalytics.trackPageview()
    }
  }

  static trackPageview(url) {
    if (!GoogleAnalytics.isLocalRequest()) {
      if (url) {
        window._gaq.push(['_trackPageview', url])
      } else {
        window._gaq.push(['_trackPageview'])
      }

      window._gaq.push(['_trackPageLoadTime'])
    }
  }

  static isLocalRequest() {
    return GoogleAnalytics.documentDomainIncludes('local')
  }

  static documentDomainIncludes(str) {
    return document.domain.indexOf(str) !== -1
  }

  static analyticsId() {    
    return 'UA-123719090-1'
  }
}

GoogleAnalytics.load()