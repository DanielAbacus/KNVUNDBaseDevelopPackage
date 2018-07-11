//
//  KNVUNDETVRelatedBasicTableViewCell.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import "KNVUNDETVRelatedBasicTableViewCell.h"

// Tools
#import "KNVUNDColourRelatedTool.h"

@interface KNVUNDETVRelatedBasicTableViewCell() <KNVUNDExpendingTableViewRelatedModelCellDelegate>{
    BOOL _hasUIInitialised; // This property will tell use that if the Cell's UI has initialised or not.... If the UI has Initialised.... there are several UI updating Method won't be called anymore.
}

// Models
@property (nonatomic, weak) KNVUNDExpendingTableViewRelatedModel *currentStoredETVModel;

// IBOutlets
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *expendingButton;

@end


@implementation KNVUNDETVRelatedBasicTableViewCell

#pragma mark - Constant
NSString *const KNVUNDETVRelatedBasicTableViewCell_SelectedBackendColour = @"#7babf744";
NSString *const KNVUNDETVRelatedBasicTableViewCell_UnSelectedBackendColour = @"#eeeeee";

#pragma mark - KNVUNDBasic
#pragma mark Class Methods
+ (NSString *)nibName
{
    return @"KNVUNDETVRelatedBasicTableViewCell";
}

+ (NSString *)cellIdentifierName
{
    return @"KNVUNDETVRelatedBasicTableViewCell";
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

#pragma mark Genral Method
- (void)updateCellUI
{
    [super updateCellUI];
    [self setupGeneralUIBasedOnModel];
    [self setupExpendedStatusUI];
    [self setupSelectedStatusUI];
    
}

#pragma mark UITableViewDelegate Related
- (void)didSelectedCurrentCell
{
    if (_currentStoredETVModel.isSelectable) {
        [_currentStoredETVModel toggleSelectionStatus];
        [self setupSelectedStatusUI];
    }
}

#pragma mark - UITableViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Step One, Update Cell UI
    [self updateCellUI];
    
    // Step Two, Add Target and Action to Button.
    [self.expendingButton addTarget:self
                             action:@selector(expendingButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Methods for Override
- (void)setupExpendedStatusUI
{
    [self setupExpendedStatusUIWithFirstTimeCheck:!_hasUIInitialised];
}

- (void)setupExpendedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    if (isFirstTime) {
        self.expendingButton.hidden = !_currentStoredETVModel.isExpendable;
        [self.expendingButton setTitle:@"+" forState:UIControlStateNormal];
        [self.expendingButton setTitle:@"-" forState:UIControlStateSelected];
    }
    self.expendingButton.selected = _currentStoredETVModel.isExpended;
}

- (void)setupGeneralUIBasedOnModel
{
    [self setupGeneralUIBasedOnModelWithFirstTimeCheck:!_hasUIInitialised];
}

- (void)setupGeneralUIBasedOnModelWithFirstTimeCheck:(BOOL)isFirstTime
{
    self.titleLabel.text = _currentStoredETVModel.associatedItem;
    if (isFirstTime) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setupSelectedStatusUI
{
    [self setupSelectedStatusUIWithFirstTimeCheck:!_hasUIInitialised];
}

- (void)setupSelectedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    if (_currentStoredETVModel.isSelected) {
        self.backgroundColor = [KNVUNDColourRelatedTool colorWithHexString:KNVUNDETVRelatedBasicTableViewCell_SelectedBackendColour];
    } else {
        self.backgroundColor = [KNVUNDColourRelatedTool colorWithHexString:KNVUNDETVRelatedBasicTableViewCell_UnSelectedBackendColour];;
    }
}

#pragma mark - Gettes && Setters
#pragma mark - Getters
- (KNVUNDExpendingTableViewRelatedModel *)relatedModel
{
    return _currentStoredETVModel;
}

#pragma mark - Setters
- (void)setCurrentStoredETVModel:(KNVUNDExpendingTableViewRelatedModel *)currentStoredETVModel
{
    _hasUIInitialised = NO;
    _currentStoredETVModel = currentStoredETVModel;
    _currentStoredETVModel.relatedCellDelegate = self;
    [self updateCellUI];
    _hasUIInitialised = YES;
}

#pragma mark - Set up
- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel
{
    if (_currentStoredETVModel != associatdModel) {
        self.currentStoredETVModel = associatdModel;
    }
}

#pragma mark - IBActions
- (IBAction)expendingButtonTapped:(UIButton *)button
{
    if (_currentStoredETVModel.isExpendable) {
        [_currentStoredETVModel toggleExpendedStatus];
        [self setupExpendedStatusUI];
    }
}

@end