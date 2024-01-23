<template>
    <body>
        <main>

            <section class="py-5 text-center container">
                <div class="row py-lg-5">
                    <div class="col-lg-6 col-md-8 mx-auto">


                        <h1 class="fw-light">The Mona Album</h1>
                        <span v-html="message"></span>


                        <p class="lead text-muted">

                            <template v-if="gallery">
                                {{ gallery.title }}
                                <br>
                                {{ gallery.description }}
                            </template>
                        </p>
                        <p>
                            <a href="#" data-bs-toggle="modal" data-bs-target="#selectImageModal" @click="getImages"
                                class="btn btn-primary my-2">Add Image From Octodex</a>
                            &nbsp;


                            <a href="#" data-bs-toggle="modal" data-bs-target="#selectImageFileModal"
                                class="btn btn-primary my-2">Add Image From File</a>

                        </p>
                    </div>
                </div>
            </section>
        </main>

        <!--Edit Gallery-->
        <div class="modal fade" id="editGalleryModal" tabindex="-1" aria-labelledby="editGalleryModalLabel"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editGalleryModalLabel">Edit Artwork</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="recipient-name" class="col-form-label">Title:</label>
                                <input type="text" class="form-control" v-model="message">
                            </div>

                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>

                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="selectImageFileModal" tabindex="-1" aria-labelledby="selectImageFileLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="selectImageFileLabel">Add Image</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="formFile" class="form-label">Choose art from file</label>
                            <input class="form-control" type="file" v-on:change="onFileChange">
                            <label for="recipient-name" class="col-form-label">Title:</label>
                            <input type="text" class="form-control" v-model="artFromFile.title">
                            <label for="message-text" class="col-form-label">Description:</label>
                            <textarea class="form-control" v-model="artFromFile.description"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" @click="reloadPage"
                            data-bs-dismiss="modal">Close</button>
                        <button type="button" @click="insertFromFile" class="btn btn-primary">Save
                            changes</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="selectImageModal" tabindex="-1" aria-labelledby="selectImageModalLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="selectImageModalLabel">Add Image</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
                            <div v-for="availableImage in this.availableImages">
                                <div class="col">
                                    <div class="card shadow-sm">
                                        <img class="bd-placeholder-img card-img-top" width="100%"
                                            v-bind:src="availableImage.uri" role="img" aria-label="Placeholder: Thumbnail"
                                            preserveAspectRatio="xMidYMid slice" focusable="false">
                                        <div class="card-body">
                                            <p class="card-text">
                                                <input class="form-check-input" type="checkbox" value=""
                                                    id="flexCheckDefault" @click="selectArt(availableImage)">
                                                {{ availableImage.title }}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" @click="reloadPage"
                            data-bs-dismiss="modal">Close</button>
                        <button type="button" @click="insertImages" class="btn btn-primary">Save changes</button>
                    </div>
                </div>
            </div>
        </div>


        <!--Edit Modal-->
        <div class="modal fade" id="editImageModal" tabindex="-1" aria-labelledby="editImageModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editImageModalLabel">Edit Artwork</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="recipient-name" class="col-form-label">Title:</label>
                                <input type="text" class="form-control" v-model="artForEdit.title">
                            </div>
                            <div class="mb-3">
                                <label for="message-text" class="col-form-label">Description:</label>
                                <textarea class="form-control" v-model="artForEdit.description"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" @click="putArtRequest(artForEdit)" class="btn btn-primary">Save
                            Artwork</button>
                    </div>
                </div>
            </div>
        </div>


        <!--ViewImage Modal -->
        <div class="modal fade" id="viewImageModal" tabindex="-1" aria-labelledby="viewImageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="viewImageModalLabel">{{ artForZoom?.title }}</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="octocat" style="max-width: 100%;">
                            <img v-bind:src="artForZoom?.uri" style="max-width: 750px" />
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <div class="album py-5 bg-light">
            <template v-if="this.gallery?.art?.length > 0">

                <div class="container">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
                        <div v-for=" art  in   this.gallery?.art  ">
                            <div class="col">
                                <div class="card shadow-sm">
                                    <template v-if="art.is_file_upload">
                                        <div v-html="art.uri"></div>
                                    </template>
                                    <template v-else="art.is_file_upload">
                                        <img class="bd-placeholder-img card-img-top" width="100%" v-bind:src="art.uri"
                                            role="img" aria-label="Placeholder: Thumbnail"
                                            preserveAspectRatio="xMidYMid slice" focusable="false">
                                    </template>
                                    <div class="card-body">
                                        <p class="card-text">{{ art.title }}</p>

                                        <p v-if="art.description" class="card-text" v-html="art.description"></p>

                                        <p v-else="art.description" class="card-text">Click Edit to describe this artwork to
                                            Mona!</p>

                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="btn-group">
                                                <button type="button" data-bs-toggle="modal" @click="viewArt(art)"
                                                    data-bs-target="#viewImageModal"
                                                    class="btn btn-sm btn-outline-secondary">View</button>
                                                <button type="button" data-bs-toggle="modal" @click="editArt(art)"
                                                    data-bs-target="#editImageModal"
                                                    class="btn btn-sm btn-outline-secondary">Edit</button>

                                            </div>
                                            <button type="button" @click="deleteImage(art.id)"
                                                class="btn btn-sm btn-outline-danger">Delete</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </template>
        </div>

    </body>
</template>

<script>
import axios from 'axios';
import { useAttrs } from 'vue';

//add sanitization function here    

export default {
    name: "Gallery",

    data() {
        return {
            availableImages: [],
            gallery: null,
            selectedArt: [],
            file: null,
            artFromFile: [],
            artForZoom: null,
            artForEdit: [],
            color: "blue",
            message: null,
        };
    },

    async mounted() {
        await axios.get("http://localhost:8081/gallery").then((response) => {
            console.log("Refreshed gallery with:", response.data)
            const gallery = response.data
            this.gallery = gallery

        }).catch((e) => {
            console.log("Failed to refresh gallery art with error:", e)
        })
        await axios.get("http://localhost:8081/gallery/art").then((response) => {

            this.gallery.art = response.data

        }).catch((e) => {
            console.log("Failed to refresh gallery with error:", e)
            console.log(e.stack);
        })
        this.gallery.art.forEach(async art => {
            if (art.is_file_upload) {
                await axios.get(art.uri).then((response) => {
                    const fileuri = "<img class='bd-placeholder-img card-img-top' width='100%' role='img' preserveAspectRatio='xMidYMid slice' focusable='false' src='data:" + response.data.mimeType + ";base64," + response.data.data + "'/>"
                    art.uri = fileuri
                }).catch((e) => {
                    console.log(e)
                })
            }
        })

    },
    methods: {
        insertFromFile() {
            var formData = new FormData();
            formData.append("file", this.file);

            axios({
                url: "http://localhost:8082/blob",
                data: formData,
                method: "POST",
                headers: {
                    "Content-Type": "multipart/form-data",
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Methods": "POST, GET, OPTIONS, DELETE",
                }
            }).then((response) => {
                console.log(response.data)
                // axios.get("http://localhost:8082/blob/" + response.data).then((response) => {
                // const fileuri = "<img class='bd-placeholder-img card-img-top' width='100%' role='img' preserveAspectRatio='xMidYMid slice' focusable='false' src='data:" + response.data.mimeType + ";base64," + response.data.data + "'/>"


                let art = {
                    title: this.artFromFile.title,
                    description: this.artFromFile.description,
                    is_file_upload: true,
                    uri: "http://localhost:8082/blob/" + response.data

                }
                axios.post("http://localhost:8081/gallery/art", art, {
                    headers: {
                        "Content-Type": false
                    }
                }).then((response) => {
                    console.log(response.data)
                }).catch((e) => {
                    console.log(e)
                })
                location.reload();
            }).catch((e) => {
                console.log(e.stack)
            })


            //   }).catch((e) => {
            //      console.log(e)
            //   })

        },

        onFileChange(e) {
            var files = e.target.files || e.dataTransfer.files;
            console.log(files);
            if (!files.length)
                return;
            this.file = files[0];
        },

        putArtRequest(artItem) {

            //add sanitization call here

            axios.put(
                `http://localhost:8081/gallery/art/${artItem.id}`, artItem,
                {
                    headers: {
                        "Content-Type": false
                    }
                }).then((response) => {
                    console.log(response);
                }).catch((e) => {
                    console.log(e)
                    console.log(e.stack)
                });
            location.reload();
        },
        viewArt(artItem) {
            this.artForZoom = artItem;
        },
        editArt(artItem) {
            this.artForEdit = artItem;
        },
        reloadPage() {
            location.reload()
        },

        selectArt(availableImage) {
            let art = {
                title: availableImage.title,
                uri: availableImage.uri
            }
            if (event.target.checked) {
                this.selectedArt.push(art)
            }
            if (!event.target.checked) {
                const index = this.selectedArt.findIndex(key => key.title === art.title)
                if (index > -1) {
                    this.selectedArt.splice(index, 1)
                    console.log(this.selectedArt)
                }

            }

        },

        deleteImage(artId) {
            axios.delete(
                `http://localhost:8081/gallery/art/${artId}`,
                {
                    headers: {
                        "Content-Type": false
                    }
                }).then((response) => {
                    console.log(response);
                }).catch((e) => {
                    console.log(e)
                });
            location.reload();
        },

        insertImages() {
            [].forEach.call(this.selectedArt, function (art) {
                axios.post("http://localhost:8081/gallery/art", art, {
                    headers: {
                        "Content-Type": false
                    }
                }).then((response) => {
                    console.log(response.data)
                }).catch((e) => {
                    console.log(e)
                })
            })
            location.reload();
        },

        getImages() {
            const RSS_URL = `https://octodex.github.com/atom.xml`;
            fetch(RSS_URL)
                .then(response => response.text())
                .then(str => new window.DOMParser().parseFromString(str, "text/xml"))
                .then(data => {
                    let contentList = data.querySelectorAll("content");
                    let indexOfImages = Array.from({ length: 6 }, () => Math.floor(Math.random() * contentList.length));

                    let availableImageList = new Array();

                    indexOfImages.forEach(indexOfImage => {
                        const el = document.createElement("html");
                        el.innerHTML = contentList.item(indexOfImage).textContent;
                        const img = el.querySelector("img");
                        console.log(img.src)

                        const p = el.querySelectorAll("p").item(1);
                        console.log(p.textContent)

                        let availableImage = {
                            title: p.textContent,
                            uri: img.src
                        };

                        availableImageList.push(availableImage);
                    });

                    this.availableImages = availableImageList;
                });
        }
    },
}
</script>

<style scoped></style>
