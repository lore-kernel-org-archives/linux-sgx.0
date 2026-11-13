Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794549473;
	b=dTHPPm15knUCVeb4Aj7E4iTPaRJRUQMqnK22JUzXlicazdK9t6G6R3sypMGe3tfWZc7c
	 UijbiZ9TsetCp9k7GiWL71XNcuzP27j167Cq6C6lodKP4w2Giwc9JeyX5iO9g50MlPaqs
	 SXj04FiCyJ0v1DBAb7VYU+nE2tC7NtzUZN9R3gzPk0Rpld7aMi19y0jejn6R/wgOVxVhr
	 io2gvX2/K91cHmyLXTVmhu5fesfE+8on5RAP1UjeiRjV/77G/LMrrbsLefVhfABxT4o7K
	 +88qPntqa/dB8tToL3cphAbjjyHbvkz+i4lEgnhLb26YBvspJf7JJt7QisCNeTkj2jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794549473;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sDUcwGzSfrw/FctpCec3z0ryFud5aUBbIS5aCK22y1k=;
	b=MKRYQXcDbvx35d/bhhmaHkhXm92zH+es+hz0qYsH3jymCY7fBwWGpVOYhOV6JN9P0rAp
	 pw12p92uy5r3dWko9HBj+tuCRiPs7FPQpGkBpjk5kbZYlXdeDPwfqbNjsHYRKEhXDAruT
	 x4us3IwrD1RnVrDUUBh2F0xHMamcI2nxuWAIfNatleFG3lZKMW/Mhr8rVBwdvgUCvvdpV
	 ajA28AcaunZqpyy/D9ilciPPj0LQAyx+A+9Xzrilpqd7ILV7n6YyqXntT6n73bn2scPYs
	 sy2RAE1rsJlj2dfZjTyS5+k8GZMlJa/dyL3y8vVs861CKcWF+QDdwGWLNGqZo2XHzXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gGoBcuBm;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AB7606A886;
	Fri, 13 Nov 2026 05:57:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47AB7606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gGoBcuBm
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794549463; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=sDUcwGzSfrw/FctpCec3z0ryFud5aUBbIS5aCK22y1k=;
	b=gGoBcuBm424ex82QHIHnaW0g5OxSPElaAibBrQfDoiSOh+htJht5iJNfjypezCII2RngBDAY+Xil6nE+bclbLJMFUzpGkEoTbpZYbKF3RWBq+GzMQFDlpMoD4CoL6KUvY4YNRPoljiSFnEw+rS/dk8Le1hJRmlOU9fNukWkzvw8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XEe4XsM_1794549455;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XEe4XsM_1794549455 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 13:57:43 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: bp@alien8.de
Cc: dave.hansen@linux.intel.com,
	jarkko@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	challvy.tee@gmail.com,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH v2] x86/crash: Disable SGX in the kdump kernel
Date: Fri, 13 Nov 2026 13:57:34 +0800
Message-ID: <20261113055734.3976582-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261113041516.GAavaO1CiqZ3otjh3I@fat_crate.local>
References: <20261113035019.3747461-1-xiangzao@linux.alibaba.com> <20261113041516.GAavaO1CiqZ3otjh3I@fat_crate.local>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 11/13/26 04:15, Borislav Petkov wrote:
> First of all this cmdline param naming is maximally unintuitive and why does
> it even exist in the first place?

Thanks for the review.

elfcorehdr= is passed by kexec, so every capture kernel boots with it
on the command line.  We use it to detect the capture kernel, the same
way is_kdump_kernel() does: that helper checks
elfcorehdr_addr != ELFCORE_ADDR_MAX, and this parameter is what sets
the address.

It also keeps the disable logic in kdump-specific code in the x86
path, as suggested in the v1 review.

We looked at two places: adding an is_kdump_kernel() check in
setup_arch(), and this handler.  We chose the latter to keep the
disable logic in kdump code rather than the generic boot path.  As an
early parameter, it clears SGX before alternatives are patched.

--
Yuanhe
