Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4A5C25B07
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Aug 2022 01:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiHKBBY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Aug 2022 21:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKBBY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Aug 2022 21:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F161EC68
        for <linux-sgx@vger.kernel.org>; Wed, 10 Aug 2022 18:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D773D6116C
        for <linux-sgx@vger.kernel.org>; Thu, 11 Aug 2022 01:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DE9C433D6;
        Thu, 11 Aug 2022 01:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660179681;
        bh=eAuHdh3DpJ5VPmtA/ewHDgZESbIHoxSgvwUyE1+baqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kzrou1sAt2n9G/qHyq1rlRQoHe6dnny32RlPaTuBfKRAoDzgr8/rVvxxLaFYw+y7R
         1iqRGPbrz/gnzuYoxMHYPcZnx8GeabnA49w1HFwpWzdChR8Q9fsMV/2bjfxTROuxx3
         j4HQQ7CshAH77Ow4WrQKPrFM8lUflnzYNBxHXbc+/ZorXikXeBeB6fPtPMkqCAFX1f
         /oGiLYFmtXBwZfZc9U7mFb0pKiuqNZ8hSMEuFIqTSEZVOnIYYd5bwpBtGqjVXegfqG
         qOD3FAMZHT2iVfge46wlrJmYMpmZBshADpqTXTEGOxRt0KQe2aLfESSHU7k5Vulf28
         goJkdijvLzV6w==
Date:   Thu, 11 Aug 2022 04:01:15 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <YvRU29VR/bkPLzS+@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org>
 <YvI6z7wgV2VQtNV7@kernel.org>
 <YvKGxIEpdnawb0bY@kernel.org>
 <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvKskgNrTDC/e8pf@kernel.org>
 <DM8PR11MB5591D9B8653A2CF9D9CD5A3EF6659@DM8PR11MB5591.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5591D9B8653A2CF9D9CD5A3EF6659@DM8PR11MB5591.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 10, 2022 at 12:09:56AM +0000, Dhanraj, Vijay wrote:
> 
> 
> > -----Original Message-----
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > Sent: Tuesday, August 9, 2022 11:53 AM
> > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> > <haitao.huang@intel.com>
> > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > 
> > On Tue, Aug 09, 2022 at 05:08:21PM +0000, Dhanraj, Vijay wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > Sent: Tuesday, August 9, 2022 9:10 AM
> > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang,
> > > > Haitao <haitao.huang@intel.com>
> > > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > >
> > > > On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen wrote:
> > > > > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen wrote:
> > > > > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > > Sent: Monday, August 8, 2022 5:18 AM
> > > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
> > > > > > > > Huang, Haitao <haitao.huang@intel.com>
> > > > > > > > Subject: Re: [PATCH] Add SGX selftest
> > > > > > > > `augment_via_eaccept_long`
> > > > > > > >
> > > > > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700,
> > > > > > > > vijay.dhanraj@intel.com
> > > > wrote:
> > > > > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > > >
> > > > > > > > > This commit adds a new test case which is same as
> > > > > > > > > `augment_via_eaccept` but adds more number of EPC pages to
> > > > > > > > > stress test
> > > > > > > > `EAUG` via `EACCEPT`.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > > > > > >
> > > > > > > > Hey, to reproduce the original issue: does it reproduce on
> > > > > > > > VM or should I run baremetal kernel?
> > > > > > > >
> > > > > > > > BR, Jarkko
> > > > > > >
> > > > > > > Hi Jarkko, The issue should be reproducible on baremetal kernel.
> > > > > >
> > > > > > Thanks.
> > > > >
> > > > > I need comment out other tests in order to make sane out of this
> > > > > :-)
> > > > >
> > > > > Mentioning this because came into realization that stress tests
> > > > > should be IMHO moved each to a separate binary (so that they can
> > > > > be run separately). Just a note (TODO) to myself.
> > > > >
> > > > > I'll work on this today again and *possibly* split your test to
> > > > > its own application to get a starting point for forementioned.
> > > >
> > > > I got
> > > >
> > > > #  RUN           enclave.augment_via_eaccept_long ...
> > > > # main.c:1241:augment_via_eaccept_long:test enclave: total_size =
> > > > 8192,
> > > > seg->size = 8192 # main.c:1241:augment_via_eaccept_long:test enclave:
> > > > total_size = 12288, seg->size = 4096 #
> > > > main.c:1241:augment_via_eaccept_long:test enclave: total_size =
> > > > 36864,
> > > > seg->size = 24576 # main.c:1241:augment_via_eaccept_long:test enclave:
> > > > total_size = 40960, seg->size = 4096 #
> > > > main.c:1259:augment_via_eaccept_long:mmaping pages at end of
> > enclave...
> > > > # main.c:1273:augment_via_eaccept_long:Entering enclave to run
> > > > EACCEPT for each page of 8589934592 bytes may take a while ...
> > > > #            OK  enclave.augment_via_eaccept_long
> > > >
> > > > The CPU used for testing was according to /proc/cpuinfo:
> > > >
> > > > model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
> > > >
> > > > I have couple of queries:
> > > >
> > > > 1. Is it possible to get dmesg output?
> > > I did check the dmesg output but couldn't find anything related to the
> > failure. Just the general log messages.
> > >
> > > > 2. Do I have to repeat the test multiple times, or does it
> > > >    occur unconditionaly?
> > > >
> > > I was able to repro every time but it was a bit sporadic for Haitao.
> > >
> > > > BR, Jarkko
> > >
> > > Also, did you set the PRMRR size to 2GB per socket in the BIOS? The
> > > issue is only reproduced for oversubscribed scenario. When I set my
> > > PRMRR to 64GB per socket, I wasn't able to repro the issue.
> > 
> > I need to revisit this.
> > 
> > Can you simply run test_sgx with gdb and see where it hits?
> > HOST_CFLAGS has apparently "-g" already.
> > 
> > > Regards, Vijay
> > 
> > BR, Jarkko
> 
> I am able to repro the issue when I reduce the PRMRR to 2B/socket but not but not able to break on the assertion failure with gdb. I also enabled debug attribute in the secs but still no avail. Anything I am missing here?
> 
> diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
> index 7de1b15c90b1..c4bccd3f5f17 100644
> --- a/tools/testing/selftests/sgx/load.c
> +++ b/tools/testing/selftests/sgx/load.c
> @@ -87,7 +87,7 @@ static bool encl_ioc_create(struct encl *encl)
>  
>         memset(secs, 0, sizeof(*secs));
>         secs->ssa_frame_size = 1;
> -       secs->attributes = SGX_ATTR_MODE64BIT;
> +       secs->attributes = SGX_ATTR_MODE64BIT | SGX_ATTR_DEBUG;
>         secs->xfrm = 3;
>         secs->base = encl->encl_base;
>         secs->size = encl->encl_size;
> 
> Regards, Vijay

I get also full pass with 2GB configuration (and also observed that 
kselftest runs much faster with this configuration).

But I looked at sgx_alloc_epc_page() and saw this:

               if (list_empty(&sgx_active_page_list))
                        return ERR_PTR(-ENOMEM);

                if (!reclaim) {
                        page = ERR_PTR(-EBUSY);
                        break;
                }

In sgx_vma_fault(), when running completely out of reclaimable pages, this
causes VM_FAULT_SIGBUS returned instead of VM_FAULT_NOPAGE:

	entry = sgx_encl_load_page(encl, addr, vma->vm_flags);
	if (IS_ERR(entry)) {
		mutex_unlock(&encl->lock);

		if (PTR_ERR(entry) == -EBUSY)
			return VM_FAULT_NOPAGE;

		return VM_FAULT_SIGBUS;
	}

Not sure if those should be re-ordered that would keep the process stuck up
until there is something to reclaim. Now we use NOPAGE to address situation
when there is actually something to reclaim but because of locking side of
things we pass reclaim=false to sgx_alloc_epc_page().

So this is kind of OOM behaviour how it works now instead of stalling
processes.

BR, Jarkko
