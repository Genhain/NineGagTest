
import Foundation
import UIKit
import CoreData

class CategoryCVDataProvider: CollectionViewDataProvider
{
    var frc: NSFetchedResultsController<Category>!
    internal var collectionViewChanges: [CollectionViewChange] = []
}

extension CategoryCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.frc) != nil {
            if let sections = frc.sections {
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self), for: indexPath) as! CategoryCell
        let categoryData = self.frc.fetchedObjects! as [Category]
        cell.setDataSource(categoryData)
        cell.setContentScrollDelegate(self.contentScrollDelegate!)
        cell.collectionView.collectionViewLayout.invalidateLayout()
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentScrollDelegate?.contentViewDidScroll(scrollView, contentOffset: scrollView.contentOffset)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.contentScrollDelegate?.contentDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension CategoryCVDataProvider: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CategoryCVDataProvider: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        
    }
    
    
}

struct CollectionViewChange {
    var object: Any
    var indexPath: IndexPath
    var type: NSFetchedResultsChangeType
    var newIndexPath: IndexPath
}
