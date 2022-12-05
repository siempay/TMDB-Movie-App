//
//  MovieTableViewCell.swift
//  TMBD Movie App
//
//  Created by Mutlu Çalkan on 2.12.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Cell selection to performsegue
    var didSelectItemAction: ((IndexPath) -> Void)? 
    
    //Movie Manager
    let movieManager = MovieManager()
    
    var movieArray : [Result]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    //Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        movieManager.performRequest(url: URLAddress().urlNowPlaying) { [self] movies in
            movieArray = movies.results
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

// MARK: - Collection View DataSource
extension MovieTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.nowPlayingCell, for: indexPath) as? NowPlayingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.posterImage.layer.cornerRadius = 15
        
        cell.posterLabel.text = self.movieArray?[indexPath.row].title
        
        let posterPath = self.movieArray?[indexPath.row].poster_path
        
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342\(posterPath ?? "/ps2oKfhY6DL3alynlSqY97gHSsg.jpg")")!)) { data, _, error in
            do{
                if let data {
                    let datas = try data
                    DispatchQueue.main.async {
                        cell.posterImage.image = UIImage(data: datas)
                    }
                }
            }catch{
                print(error)
            }
        }.resume()
        return cell
    }
}

// MARK: - Collection View Delegate
extension MovieTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAction?(indexPath)
    }
}
