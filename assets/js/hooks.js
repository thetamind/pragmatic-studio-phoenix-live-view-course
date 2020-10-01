let Hooks = {}
Hooks.StashForm = {
    beforeDestroy() {
        const formData = new FormData(this.el)
        const params = Object.fromEntries(formData.entries())
        this.pushEvent("stashform", params)
    },
}

export default Hooks
