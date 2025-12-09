using System.Collections.Generic;
using UnityEngine;

public class PacmanController : MonoBehaviour
{
    Vector3 directionToMove;
    Rigidbody rb;
    public float moveSpeed;

    public List<GameObject> ghosts;
    float ghostTimer = 10;
    public float ghostDuration;
    public Material hologramMaterial;
    Material ghostStartingMaterial;
    bool activated;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        ghostStartingMaterial = ghosts[0].GetComponent<MeshRenderer>().material;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            directionToMove = new Vector3(-1, 0, 0);
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            directionToMove = new Vector3(0, 0, -1);
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            directionToMove = new Vector3(1, 0, 0);
        }

        if (Input.GetKeyDown(KeyCode.W))
        {
            directionToMove = new Vector3(0, 0, 1);
        }

        rb.linearVelocity = directionToMove * moveSpeed;


        ghostTimer += Time.deltaTime;

        if (ghostTimer > ghostDuration && activated)
        {
            activated = false;
            DeactivatePowerup();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("wall"))
        {
            directionToMove = Vector3.zero;
            rb.linearVelocity = Vector3.zero;
            this.gameObject.transform.position = Vector3Int.RoundToInt(this.gameObject.transform.position);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("coin"))
        {
            Destroy(other.gameObject);
        }

        if (other.gameObject.CompareTag("bigCoin"))
        {
            ActivatePowerup();
            Destroy(other.gameObject);
        }
    }

    void ActivatePowerup()
    {
        ghostTimer = 0;
        activated = true;

        foreach (GameObject ghost in ghosts)
        {
            ghost.GetComponent<MeshRenderer>().material = hologramMaterial;
        }
    }

    void DeactivatePowerup()
    {
        foreach (GameObject ghost in ghosts)
        {
            ghost.GetComponent<MeshRenderer>().material = ghostStartingMaterial;
        }
    }
}
