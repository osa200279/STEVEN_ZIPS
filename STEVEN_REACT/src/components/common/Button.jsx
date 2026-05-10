export const Button = ({ children, variant = 'default', size = '', ...props }) => {
  const className = `c-btn ${variant !== 'default' ? `c-btn--${variant}` : ''} ${size ? `c-btn--${size}` : ''}`;
  return <button className={className} {...props}>{children}</button>;
};