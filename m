Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE06BC433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 18 May 2022 00:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiERAqW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 May 2022 20:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiERApz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 17 May 2022 20:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF9CB859
        for <linux-sgx@vger.kernel.org>; Tue, 17 May 2022 17:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0735A61536
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 00:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD69C385B8;
        Wed, 18 May 2022 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652834752;
        bh=z87A6O404utXiyMmeUJk5rvEJSIRfaB4gJrHWtw8+Hw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFsSdXWdtKlbxUZSiC2c7p48q1Q+bRx6Wqgt5Tu683rk9lOpXP/1saoR+mP7kmDtM
         9CjIdHav5zFaS3qCW4OLu8kVKa+fbyjBVtffeGHNwAcXwd9obULbip+82vtyhmttCV
         QWiXDis2wu8C45h+Pd+hS9NP1rcGowizZDopxH4P3/Sk9i4SgMNNgJuREyjTAOYhkc
         T0lPflbWK1EX9hL2JS4r+MJtw/D6is3z2uBie6qRNLb/nlyYha7BH76lTpPLZpq3Xd
         YZ1OMwq18qNJgYJBexB/yrT3PpCY6tPtV/+wsbSIBGz+X8jIRoZoYy3J+7t5yzo/vC
         Lj9evcq4Q/29g==
Date:   Wed, 18 May 2022 03:47:32 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        reinette.chatre@intel.com
Subject: Re: VMA's not getting merged
Message-ID: <YoRCJCtSGfxjwu2w@iki.fi>
References: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
 <c148ab48-1b70-6e20-5742-b0b2dc014dc3@intel.com>
 <YoKb5P+VixJUn6xT@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoKb5P+VixJUn6xT@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 16, 2022 at 09:45:56PM +0300, Jarkko Sakkinen wrote:
> On Mon, May 16, 2022 at 07:13:42AM -0700, Dave Hansen wrote:
> > On 5/14/22 18:20, Jarkko Sakkinen wrote:
> > > Looks like VMA's do not get merged properly:
> > ...
> > > 7f8f0800b000-7f8f08014000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f08014000-7f8f08025000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f08025000-7f8f08046000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f08046000-7f8f0804a000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f0804a000-7f8f0804b000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f0804b000-7f8f0804c000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f0804c000-7f8f0804d000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > > 7f8f0804d000-7f8f0804e000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 
> > I remember some issue with VM_IO VMAs not getting merged, but I don't
> > remember how we fixed or addressed it.
> > 
> > Seems like something we can and should fix, though.
> 
> Access pattern here is series of small adjacent mmaps (brk()).
> 
> During upstreaming vma_close callback was eliminated to allow VMA's getting
> merged. I'll try to trace the condition in the call path triggering this.
> 
> BR, Jarkko

I wrote a small bpftrace script:

#include <linux/fs.h>

k:vma_merge
/strncmp(str(((struct vm_area_struct *)arg1)->vm_file->f_path.dentry->d_name.name), "sgx_enclave", 11) == 0/
{
	@merge[tid] = true;
}

kr:vma_merge /@merge[tid] && retval > 0/
{
	@merged = count();
	delete(@merge[tid]);
}

kr:vma_merge /@merge[tid]/
{
	@unmerged = count();
	delete(@merge[tid]);
}

When running with the same payload, I get:

@merged: 0
@unmerged: 209

So it gets down to vma_merge but each time the function returns NULL.

BR, Jarkko
