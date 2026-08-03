using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FamilyVeda.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class _20260804_ALL_EnforceMemberAccountOwnership : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_members_user_id",
                table: "members");

            migrationBuilder.CreateIndex(
                name: "ix_members_user_id",
                table: "members",
                column: "user_id",
                unique: true,
                filter: "user_id IS NOT NULL");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_members_user_id",
                table: "members");

            migrationBuilder.CreateIndex(
                name: "ix_members_user_id",
                table: "members",
                column: "user_id");
        }
    }
}
