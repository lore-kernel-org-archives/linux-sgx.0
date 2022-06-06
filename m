Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AC9C433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Jun 2022 07:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiFFHXX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jun 2022 03:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiFFHXP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Jun 2022 03:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5FDD51
        for <linux-sgx@vger.kernel.org>; Mon,  6 Jun 2022 00:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C894DB8093C
        for <linux-sgx@vger.kernel.org>; Mon,  6 Jun 2022 07:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C88C34119;
        Mon,  6 Jun 2022 07:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654500191;
        bh=PNhgSSsHAvD69NeVAB6Wa8ijXIOigjWE+3AoS2wgwAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FuWdZe+EYK391k63mlVsv/DY1HOhvQaEX5qYUGbkRllsr7q5gKW4DPl5tR07ILWuR
         FLdz4g/o5wWZccROt5E2pHVGT/PDdA0OHwypeUy2m+SDvnUTynAOFECQveNuVqDPTf
         RHLdLRX8Juute3v48hEjWqiznLt6F09yC9HeTdE+UVlDHJL1x/WFy9pS5TIkxFPmG2
         /rfBhkVIdbVkDsXMcZIA3/bj1Zw3vFFqLiPZ9bqtSlEhoz5SBOaj9e5fLNXNS24ecn
         neskkwmUe2w87Kdxbr533PyV38ppaXY8+hZapmb7Goo5LagjjVumLRK5WFPt7a/lvP
         ZuOWOnVOitJaQ==
Date:   Mon, 6 Jun 2022 10:21:15 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        reinette.chatre@intel.com,
        Nathaniel McCallum <nathaniel@profian.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: VMA's not getting merged
Message-ID: <Yp2q68qYtdpR+Z+T@iki.fi>
References: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
 <c148ab48-1b70-6e20-5742-b0b2dc014dc3@intel.com>
 <YoKb5P+VixJUn6xT@kernel.org>
 <YoRCJCtSGfxjwu2w@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoRCJCtSGfxjwu2w@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 18, 2022 at 03:47:32AM +0300, Jarkko Sakkinen wrote:
> On Mon, May 16, 2022 at 09:45:56PM +0300, Jarkko Sakkinen wrote:
> > On Mon, May 16, 2022 at 07:13:42AM -0700, Dave Hansen wrote:
> > > On 5/14/22 18:20, Jarkko Sakkinen wrote:
> > > > Looks like VMA's do not get merged properly:
> > > ...
> > > > 7f8f0800b000-7f8f08014000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f08014000-7f8f08025000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f08025000-7f8f08046000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f08046000-7f8f0804a000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f0804a000-7f8f0804b000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f0804b000-7f8f0804c000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f0804c000-7f8f0804d000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > > 7f8f0804d000-7f8f0804e000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 
> > > I remember some issue with VM_IO VMAs not getting merged, but I don't
> > > remember how we fixed or addressed it.
> > > 
> > > Seems like something we can and should fix, though.
> > 
> > Access pattern here is series of small adjacent mmaps (brk()).
> > 
> > During upstreaming vma_close callback was eliminated to allow VMA's getting
> > merged. I'll try to trace the condition in the call path triggering this.
> > 
> > BR, Jarkko
> 
> I wrote a small bpftrace script:
> [SNIP]

I started looking into this again by writing a short program:

// SPDX-License-Identifier: GPL-2.0
/* Derivative of tools/testing/selftests/sgx */

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <asm/sgx.h>

#define ENCL_SIZE (1 << 24) /* 16 MB */

struct sgx_secs {
	__u64 size;
	__u64 base;
	__u32 ssa_frame_size;
	__u32 miscselect;
	__u8  reserved1[24];
	__u64 attributes;
	__u64 xfrm;
	__u32 mrenclave[8];
	__u8  reserved2[32];
	__u32 mrsigner[8];
	__u8  reserved3[32];
	__u32 config_id[16];
	__u16 isv_prod_id;
	__u16 isv_svn;
	__u16 config_svn;
	__u8  reserved4[3834];
} __attribute__((packed));

void dump_maps(void)
{
	char maps_line[256];
	FILE *fp = fopen("/proc/self/maps", "r");
	if (fp != NULL)  {
		while (fgets(maps_line, sizeof(maps_line), fp) != NULL) {
			maps_line[strlen(maps_line) - 1] = '\0';

			if (strstr(maps_line, "/dev/sgx_enclave"))
				printf("%s\n", maps_line);
		}

		fclose(fp);
	}
}

int main(void)
{	
	const char device_path[] = "/dev/sgx_enclave";
	struct sgx_enclave_create ioc;
	struct sgx_secs secs;
	int fd = -1;
	void *area;
	void *addr;
	int ret;

	area = mmap(NULL, ENCL_SIZE * 2, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (area == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	memset(&secs, 0, sizeof(secs));
	secs.ssa_frame_size = 1;
	secs.attributes = 4;
	secs.xfrm = 3;
	secs.base = ((uint64_t)area + ENCL_SIZE - 1) & ~(ENCL_SIZE - 1);
	secs.size = ENCL_SIZE;

	munmap(area, secs.base - (uint64_t)area);
	munmap((void *)(secs.base + ENCL_SIZE), (uint64_t)area + ENCL_SIZE - secs.base);

	fd = open(device_path, O_RDWR);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	ioc.src = (unsigned long)&secs;
	ret = ioctl(fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
	if (ret) {
		perror("ioctl");
		exit(1);
	}

	addr = mmap((void *)secs.base, ENCL_SIZE / 2, PROT_READ | PROT_WRITE,
		    MAP_SHARED | MAP_FIXED, fd, 0);
	if (addr == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	addr = mmap((void *)(secs.base + ENCL_SIZE / 4), ENCL_SIZE / 2, PROT_READ | PROT_WRITE,
		    MAP_SHARED | MAP_FIXED, fd, 0);
	if (addr == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	dump_maps();

	exit(0);
}

It creates two RW VMA's:

1. 8 MB VMA.
2. Another 8 MB VMA that overlaps the first by 4 MB.

Expected result ought to be 12 MB RW VMA.

Then I wrote a another eBPF script:

#include <linux/fs.h>
#include <linux/mm.h>

k:vma_merge
/strncmp(str(((struct vm_area_struct *)arg1)->vm_file->f_path.dentry->d_name.name), "sgx_enclave", 11) == 0/
{
	@merge[tid] = true;
}

kr:vma_merge /@merge[tid]/
{
	printf("vma_merge: retval = %d\n", retval);
}

k:__vma_adjust
/strncmp(str(((struct vm_area_struct *)arg0)->vm_file->f_path.dentry->d_name.name), "sgx_enclave", 11) == 0/
{
	@adjust[tid] = true;
}

kr:__vma_adjust /@adjust[tid]/
{
	printf("__vma_adjust: retval = %d\n", retval);
}

kr:__mpol_equal
{
	printf("__mpol_equal: retval = %d\n", retval);
}

This gives me:

$ sudo bpftrace sgx-vma-merged.bt 
Attaching 5 probes...
__vma_adjust: retval = 0
__vma_adjust: retval = 0
vma_merge: retval = 0
vma_merge: retval = 0
vma_merge: retval = 0

Two __vma_adjust() calls are result of mapping enclave VMA on top
of anonymous VMA. __vma_adjust() is never reached when overlapping
VMA is mapped.

Another noworthy thing is that mpol_equal() is never reached, and
the condition in vma_merge  is like this:

	if (prev && prev->vm_end == addr &&
			mpol_equal(vma_policy(prev), policy) &&
			can_vma_merge_after(prev, vm_flags,
					    anon_vma, file, pgoff,
					    vm_userfaultfd_ctx, anon_name)) {

So this led to the obvious fact: it's the VM_SPECIAL check in the
beginning of the vma_merge() function.

I found at least this old ref on removing the close callback:

https://lore.kernel.org/linux-sgx/20190708145707.GC20433@linux.intel.com/

So I guess we did not take this VM_SPECIAL check in the account...

On bright side: this can be obviously worked around in the
user space. E.g. in "brk()" you do mmap() over the whole
new VMA instead of the new subportion of it, and so forth.

And all in all the whole merging thing can be worked around
in the user space. So it's not a dead end but still would
be nice to have kernel to do this automatically.

Dave: so my question is this: can VM_SPECIAL check be
relaxed somehow, or should it be just documented that
enclave VMAs do not get merged?

Anyway, if this was a blocker for getting SGX2 patches to
5.19, it should not be. I did all the research with
my i5-9600KF desktop, which is oddbal CPU with flexible
launch control, and no SGX2. Neither was any SGX2 patches
applied.

BR, Jarkko
