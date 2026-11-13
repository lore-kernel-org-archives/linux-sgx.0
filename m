Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573934;
	b=uyh/1za/wBtSrABayTFCTgYtpv5CTBuXMSKZP91o7+2Mu0lx6fMoRCQ1iDJ4C/YT/hsG
	 xtdGEUG/pJodMDLsEF34ZHqrO6VENAsl9JGDBaCwCJIg7gtcrkyoGkywGJlmf41dsGrFe
	 IPTWhmqFWRvdNNHEArZ3RWthj5owBZrNtEceD2jQOiDjlnFKuak6TWkxsZYNG5duewlng
	 4dluZNjvmSIg9vjW4z+0bjA12Rys+uuHK5Mux+BccPu78W82LUfGSZYlLqhndNmFe/MvH
	 Izm2H66HZVFTyInTnCxvyk+ZrcSSdS07Y0p9CoqGPKLZp9DPdsTtN/ci98LnZEDOlVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=qAdRMe27UO0j9h/LxR0eO7g2Q0xbqUQINwEmxPoZbJM=;
	b=T8/OPbnURTXAR8mLERPo+II3smgZIxw2ncLlaFjdwpUEwGSW04On9a1W2bMVrNHhGBBL
	 CIIAl8gzLiqOqoaiGFPyxohxw+8haLSmgoLalp5HW5y99ZIxNWbx/7zTgHqLh/Cpo0keP
	 uIjfpqAR3iOl8J0OY1jwdg3UojsOVhvTA/k+l+k2MQI+gcmo9v4CZYCjLZtwaHAFC//U6
	 Ahv5dJ+KiqDoko9cefUMX/nELrm911yJvonNT1cucHMUTS+fyZx/TjPLXkeTGjrLlJRyI
	 Y10bkg+VcWt3yZDAzyH9rgjej6zAeByTztSkJ8bXKaK2GRjWIlGZk1ZaDb/diSY03NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnAD6EWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E1606A331;
	Fri, 13 Nov 2026 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnAD6EWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EACF1F000C5;
	Fri, 13 Nov 2026 12:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573934;
	bh=qAdRMe27UO0j9h/LxR0eO7g2Q0xbqUQINwEmxPoZbJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnAD6EWcxhWGX0zi+7smysIwX+Ivw2YSPVtz4BmCucqLUGs302jrMl2iFhjPKDe3v
	 GigUU/6Zlse0jQ6+9gQTgd3eGM8OcQRZD+nWdx9y2gjQ8xzg4X8kgUkxUvHsq4cTiy
	 w26TYJQQmeAAaryfFEqeWfZCiHNkWQKZOQooLRm6IYwE8Wc9Cy+YnmOfaJgbOPCUiF
	 1X+0p76eSN7IbNSN/DOlEM9HgiL8GkIZA8eyWcPuxVc4njIHYvcK6maqXe44JR6ZRF
	 G9BH+sEUVbfYus6sSHcJfctzM3lh1m5vOQsiF+bQiUrt29G1v8G4uSsr2dP2SuM+ye
	 kw9Oo7rmm7YoA==
From: Thorsten Blum <blum@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <blum@kernel.org>
Subject: [PATCH RESEND v2 3/3] x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit()
Date: Fri, 13 Nov 2026 13:44:52 +0100
Message-ID: <20261113124448.70586-8-blum@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113124448.70586-5-blum@kernel.org>
References: <20261113124448.70586-5-blum@kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1098; i=blum@kernel.org; h=from:subject; bh=eh8G5JQqfW6fjcCppCY80Zz0Iq/hvPYPQBnR51vLosU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnf2dwFOcV/nuq25dNSXPAgRX3H4mO6O5YV536Yz2+++ +J/3gVyHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRjVyMDO9/KX8NWjCNUf3S rqS/tvwJtZO6poZWHTZfNk32wNfP7tcZGc7WbHp+0t3iYPERxwKJcuFPGQt9fO8vnWLWs5JNqCh QhRMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Both sgx_ioc_enclave_init() and __sgx_virt_einit() use the same 304-byte
launch token. Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit() instead of
maintaining a second local definition.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 arch/x86/kernel/cpu/sgx/virt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a1933ddc6fc..7c5ac5d38ee1 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -395,9 +395,8 @@ static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
 	 * All other checks deferred to ENCLS itself.  Also see comment
 	 * for @secs in sgx_virt_ecreate().
 	 */
-#define SGX_EINITTOKEN_SIZE	304
 	if (WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
-			 !access_ok(token, SGX_EINITTOKEN_SIZE) ||
+			 !access_ok(token, SGX_LAUNCH_TOKEN_SIZE) ||
 			 !access_ok(secs, PAGE_SIZE)))
 		return -EINVAL;
 
