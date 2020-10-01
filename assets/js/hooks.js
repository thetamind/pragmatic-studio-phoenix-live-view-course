let Hooks = {}

Hooks.InfiniteScroll = {
    mounted() {
        console.log("Footer added to DOM!", this.el)
        this.observer = new IntersectionObserver((entries) => {
            const entry = entries[0]
            if (entry.isIntersecting) {
                console.log("footer is visible")
                this.pushEvent("load-more")
            }
        })

        this.observer.observe(this.el)
    },
    updated() {
        const pageNumber = this.el.dataset.pageNumber
        console.log("updated", pageNumber)
    },
    destroyed() {
        this.observer.disconnect()
    },
}

Hooks.StashForm = {
    beforeDestroy() {
        const formData = new FormData(this.el)
        const params = Object.fromEntries(formData.entries())
        this.pushEvent("stashform", params)
    },
}

export default Hooks
