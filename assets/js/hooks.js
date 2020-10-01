import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.css"

let Hooks = {}

Hooks.DatePicker = {
    mounted() {
        this.picker = flatpickr(this.el, {
            enableTime: false,
            dateFormat: "F d, Y",
            onChange: this.handleDatePicked.bind(this),
        })
    },
    handleDatePicked(_selectedDates, dateStr, instance) {
        console.log(dateStr, instance)
        this.pushEvent("date-picked", { date: dateStr })
    },
}

Hooks.InfiniteScroll = {
    mounted() {
        console.log("Footer added to DOM!", this.el)
        this.observer = new IntersectionObserver(
            ([entry]) => {
                if (entry.isIntersecting) {
                    console.log("footer is visible")
                    this.pushEvent("load-more")
                }
            },
            { threshold: 0.5 }
        )

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
