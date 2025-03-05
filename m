Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA004A06;
	Wed,  5 Mar 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741150823; cv=none; b=a/B4LDrfNT3bNDoJWVqEKbCO8ndqyfsPOlDC8uqI7SsOvorOiAAW7bIbsvVYSDYTQVrCOzQ7nyvJQWGaRld7nv8h1iiUaClwWGytZ9lEt9x2khNH3b7oDoOJY6MBblChkdoql3n58tD35AdGlPHl4rkAfxy1xW4YGLPssepMPHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741150823; c=relaxed/simple;
	bh=Tu9pHHMhYpuvyvA4UcT8a/MRI55uAHM1EzWCIW5bxXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INUGUFOeGW5cPky96bL9U2EO3i9xBBmzzVE7N/Vhm2e+uihicUwRM4akKGJe68hYHoe9ehqf5mB7uEhLWMLGZkMq5kz5wCAtp7L0GQ6CUz4sAm0yOlBKdlFEPaL5Jsx49wuvStjNHRkVQ/Nnf7hWh82RlGIkICzVlOWG1g/3lMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwVbWvR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwVbWvR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ECCC4CEE2;
	Wed,  5 Mar 2025 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741150822;
	bh=Tu9pHHMhYpuvyvA4UcT8a/MRI55uAHM1EzWCIW5bxXc=;
	h=From:To:Cc:Subject:Date:From;
	b=XwVbWvR7rGQYmhkjddx9319FAP7mfMYhh/7rU0uE/Dqh1myjLuzWr/XfC75jOAO5Y
	 G9NO7jpSiYPZuIxgerUP+6sASYSaRGjHA3Z4OdIp1AQBsUzeWA9jN99ARkrAj0NWBb
	 VWaEJI1beXhBgyEKcY1G/fH4mJWTYemzuap5JFgRm+wEnJTYVjohKcmmSSR6ilp1DM
	 sqBg8o6zU/8sfDqd9wD7cqhmHKZ2VaKiLYdhgnKyvuZsho9/XB9ZDk5ByudmjrK/+/
	 vjNHkQhmaUydnn1RJzcMoC5JXorw006MiJoj4x9ii4Z7fy+jnlFaBzzaFZJj9x/H2q
	 quCV/lQwGCVYg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-sgx@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Borislav Petkov <bp@suse.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] arch/x86: Fix size overflows in sgx_encl_create()
Date: Wed,  5 Mar 2025 07:00:05 +0200
Message-ID: <20250305050006.43896-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The total size calculated for EPC can overflow u64 given the added up page
for SECS.  Further, the total size calculated for shmem can overflow even
when the EPC size stays within limits of u64, given that it adds the extra
space for 128 byte PCMD structures (one for each page).

Address this by pre-evaluating the micro-architectural requirement of
SGX: the address space size must be power of two. This is eventually
checked up by ECREATE but the pre-check has the additional benefit of
making sure that there is some space for additional data.

Cc: stable@vger.kernel.org # v5.11+
Fixes: 888d24911787 ("x86/sgx: Add SGX_IOC_ENCLAVE_CREATE")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-sgx/c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain/
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v3: Updated the commit message according to Dave's suggestion and added
    fixes tag.
v2: Simply check the micro-architetural requirement in order to address
    Dave's comment:
    https://lore.kernel.org/linux-sgx/45e68dea-af6a-4b2a-8249-420f14de3424@intel.com/
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b65ab214bdf5..776a20172867 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -64,6 +64,13 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
+	/*
+	 * ECREATE would detect this too, but checking here also ensures
+	 * that the 'encl_size' calculations below can never overflow.
+	 */
+	if (!is_power_of_2(secs->size))
+		return -EINVAL;
+
 	va_page = sgx_encl_grow(encl, true);
 	if (IS_ERR(va_page))
 		return PTR_ERR(va_page);
-- 
2.48.1

