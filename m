Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912835;
	b=nAoVF5S/LUn3q/Cr6lEOtmb7zLJwv81KPaPg3cqYpr8/qI8CSGdGSTTgph9dyBaM9bXH
	 OlD9fc9Isuz1TNDfttjFKMkL57tLwFyphOZIr7EYICW6hRHpec8LqajFAhTuprSXKUWWQ
	 6+mvh0lFAEmNMlNFVEf8HH/76QuGiwWuljwB8dXstrO3H8XkqJCVRpH5rjFWJWP4QmbC+
	 qyzAu312nb+FfAfovdz8bB/RZg/XfjDQIWDQl8YykWxJk5hi5Duzr4ibSPsVBT4IsxDX/
	 RdV2+Wy+mJXFvxmQ1Y9BoKX/DAWLEbk3yNiJYbDhfY+CbsvBYvhbGyuPyW6WDhzRczA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912835;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=QKT0z8QtIRwzKrfDYLgpmoyX9J+/idevkgO1HnXZit4=;
	b=u89ROZGtLdgr0o7EmiOiXcbYCsYDfN8GlbsgMuuIzauGNin0AwbZnTQQOAk5bevFxN8W
	 o0xxFASJ1AbhqEcQAzNAVCcJhvjCfNXdBVnwO5Z7WQbKzAbZxOede191DsumpgIizIYKn
	 0Jy6OHsOW1ne3t6IjbYapzPGA8KUJEg2MChFEf4HjVZKsy/sR+1qSH7kFuIbabZgtGLQk
	 InFjc+YyWWpGQSS5uJRug2NiruvrvrjAvyq0HnIhz5bDJufsUs3PV8+bs72+d1L1Mo7mc
	 XEvwvBVCe+PxclktVqcxpZsBB75N18LfLaiwMMkqBDjw2HtHj46eCev+HVzZmgQ32pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnuBqofl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AD9606A335;
	Thu,  5 Nov 2026 21:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnuBqofl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0881F008BE;
	Thu,  5 Nov 2026 21:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912835;
	bh=QKT0z8QtIRwzKrfDYLgpmoyX9J+/idevkgO1HnXZit4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RnuBqoflWBl9+my+oc0dxGf7vwqGAIPn/FsGegfNU3dHcec/WKV86s6Ur1Z7CgphR
	 XKnhR+RNjTNO8xHOfu/7SF8YH25vN+805KwkJu0FanhjtyA5pyhvbbpwpubqNIFDqI
	 0TVcpTKSq0Hbsoi1IvuBwqBkbcg2LUnI8ztcdNM7aUjh5w7hvqpQ6VfM7GqHQzO7sB
	 P65idNuN5d5q0GV/XG9x/f4N6e/Z8fjyllKisCJ9sQgGmYELUKRoe5PiuZNsJh9pU5
	 chtN+L8dJARPPHvocVhTuHejP5A11y7PUl2FEC/P7We+rpc+2vc3NxNzEGRFg75tiJ
	 ON7wUjneXfb7Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:37 +0000
Subject: [PATCH 06/14] udf: convert mmap hook to mmap_prepare
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-mmap_prepare-v1-6-c56aadfbab8a@kernel.org>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
To: Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1166; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DLdQ29COL0zGmxo/RqnqfZh7M8nmGGQT+1l47aYTRPY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF+TVmThWvlNcPmraFeJkEjHwxYvPkgIt/wtrxeoz
 +A9ez2ho5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABO5fZvhn+2396kibN6ZSya4
 8c9Md3ietX1BVNqe62l2F/Zvfvurg4nhf5JVc2LZzaRWi98fwrc7JT79lmb6P+mw/7Z3Hc9+hFT
 68QIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only updates the access time and sets the VMA operations.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/udf/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 02e9314818dc..d5e80c6cae96 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -190,10 +190,10 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int udf_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int udf_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	file_accessed(file);
-	vma->vm_ops = &udf_file_vm_ops;
+	file_accessed(desc->file);
+	desc->vm_ops = &udf_file_vm_ops;
 
 	return 0;
 }
@@ -202,7 +202,7 @@ const struct file_operations udf_file_operations = {
 	.read_iter		= generic_file_read_iter,
 	.unlocked_ioctl		= udf_ioctl,
 	.open			= generic_file_open,
-	.mmap			= udf_file_mmap,
+	.mmap_prepare		= udf_file_mmap_prepare,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
 	.fsync			= simple_fsync,

-- 
2.56.0

