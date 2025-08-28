document.addEventListener('DOMContentLoaded', function () {


    const MAX_SIZE = 30;
    const MIN_SIZE = 20;
    const MAX_DISTANCE = 50;

    /**
     * calculate the player icon size based on distance
     * @param {number} distance 
     * @returns {number} 
     */
    function calculateSize(distance) {
        let size = MAX_SIZE - (distance / MAX_DISTANCE) * (MAX_SIZE - MIN_SIZE);
        return Math.max(MIN_SIZE, size);
    }


    /**
    * initialize selection 
    * @param {Object} data id, x, y, distance
    * @returns {void}  
    */
    function initSelector(data) {

        const players = document.createElement('div');
        players.className = 'players-selected';
        document.body.appendChild(players);

        for (const player of data) {
            const { id, x, y, distance } = player;

            const playerDiv = document.createElement('div');
            playerDiv.className = 'player';

            const playerImg = document.createElement('img');
            playerImg.src = 'assets/icon.png';
            playerImg.alt = `Player ${id}`;
            let size = calculateSize(distance);
            playerImg.style.width = `${size}px`;
            playerImg.style.height = `${size}px`;

            playerDiv.appendChild(playerImg);

            playerDiv.style.position = 'absolute';
            playerDiv.style.left = `${x * 100}vw`;
            playerDiv.style.top = `${y * 100}vh`;


            playerDiv.addEventListener('click', function () {
                fetch(`https://vorp_lib/selector`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({ id })

                });
                players.remove();
            });

            playerDiv.addEventListener('mouseover', function () {
                fetch(`https://vorp_lib/selectorSound`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({})
                });
            });

            players.appendChild(playerDiv);
        }
    }

    /**
     * update player selection
     * @param {Object} data id, x, y, distance
     * @returns {void}
     **/
    function updateSelector(data) {
        const playersContainer = document.querySelector('.players-selected');
        if (!playersContainer) return;

        for (const player of data) {
            const { id, x, y, distance } = player;
            const playerDiv = playersContainer.querySelector(`.player img[alt="Player ${id}"]`);
            if (playerDiv) {
                let size = calculateSize(distance);
                playerDiv.style.width = `${size}px`;
                playerDiv.style.height = `${size}px`;
                playerDiv.parentElement.style.left = `${x * 100}vw`;
                playerDiv.parentElement.style.top = `${y * 100}vh`;
            }
        }

    }

    /**
     * cancel player selection
     * @returns {void}
     * */
    async function cancelSelector() {
        const playersContainer = document.querySelector('.players-selected');
        if (!playersContainer) return;

        playersContainer.remove();
        fetch(`https://vorp_lib/selector`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ id: -1 })
        });

    }

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') cancelSelector();
    });

    window.addEventListener('message', function (event) {
        const { data } = event.data;

        if (data.type === 'select')
            initSelector(data.players);

        if (data.type === 'update')
            updateSelector(data.players);
    });
});
