Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417D7C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Jan 2022 17:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244703AbiAXRm2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Jan 2022 12:42:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40904 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbiAXRm2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 24 Jan 2022 12:42:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3C0612FB
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jan 2022 17:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82D6C340E5;
        Mon, 24 Jan 2022 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643046147;
        bh=wd87SgBlOi5zeec1r8fY7Qg24T4QeA2BVbxK7HQvgJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2PqtYhkbTYZj/xfeaPjaRyUNXbFnN8sIY2iIDgrcl/xK9jbb6tiVSx8GFoKSKhG6
         mSqns4sXt5yhP8ki+gLIfEucOsgMHiJZynhjWN7oTs9DHNINmdWePVAGWxTl50QUgw
         n7YlOoZqUCtQ7ruAgAQxGvryZZPjNEV5HdZ4EVGR8qo9rQ9Y8qqtsfQbqV8/kFdVTA
         HtQaNTvWFRim2bkJegVP9HoDlNDtTjJU7o7Ee0ZP/Fm/gzIbSiHFwYvlOZ1EFcm0Vz
         JS6X9AZZCnyZDtr89/TirBGaLabRZtgeYYCMYSRVi1hjUe28cT2bY1ly7RraZsfCPf
         HV/kNwe4Z6tZQ==
Date:   Mon, 24 Jan 2022 19:42:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: Testing 5.17 bugfix material
Message-ID: <Ye7k7b1x8OnQcJgL@iki.fi>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
 <op.1gevpaxgwjvjmi@hhuan26-mobl1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1gevpaxgwjvjmi@hhuan26-mobl1.mshome.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jan 22, 2022 at 01:15:01PM -0600, Haitao Huang wrote:
> Hi Dave,
> 
> On Fri, 21 Jan 2022 13:57:50 -0600, Dave Hansen <dave.hansen@intel.com>
> wrote:
> 
> > Hi Everyone,
> > 
> > There are a few SGX fixes that have showed up in the last week or so,
> > mostly around RAS and fixing the backing storage issues.  Could folks
> > please give this branch a good thrashing?
> > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
> > 
> > I'm planning to send this bunch up to Linus after 5.17-rc1 comes out.
> > 
> > Kristen, I really dug into the changelogs of your two patches to make it
> > more clear that they are bugfix and stable@ material.  I'd appreciate
> > some additional eyeballs there.
> 
> When testing this with a large enclave loaded by Intel runtime, we saw it
> hang
> on EADD ioctl and the ioctl never returns.
> 
> Also noticed the selftest fails on oversub but the return errno is EINTR not
> ENOMEM as expected.
> 
> When user space register signal handler with SA_RESTART flag, EINTR would
> be an auto restart of ioctl. So that might be what's going on with Intel
> runtime test. And I suspect following code may cause infinite restart of the
> ioctl:
> 
> struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
> {
>       struct sgx_epc_page *page;
> 
>       for ( ; ; ) {
>           page = __sgx_alloc_epc_page();
>           if (!IS_ERR(page)) {
>               page->owner = owner;
>               break;
>           }
> 
>           if (list_empty(&sgx_active_page_list))<-- should also check
> sgx_nr_available_backing_pages?
>               return ERR_PTR(-ENOMEM);
> 
>           if (!reclaim) {
>               page = ERR_PTR(-EBUSY);
>               break;
>           }
> 
>           if (signal_pending(current)) {
>               page = ERR_PTR(-ERESTARTSYS);<---- this is the only exit of
> the for loop when backing store limit reaches.
>               break;
>           }
> 
>           sgx_reclaim_pages(); <---- no checking for backing store fail due
> to limit here.
>           cond_resched();
>       }
> 
> Thanks
> Haitao

Haitao, this does not match what I see in tip/x86/sgx:

struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
{
	struct sgx_epc_page *page;

	for ( ; ; ) {
		page = __sgx_alloc_epc_page();
		if (!IS_ERR(page)) {
			page->owner = owner;
			break;
		}

		if (list_empty(&sgx_active_page_list))
			return ERR_PTR(-ENOMEM);

		if (!reclaim) {
			page = ERR_PTR(-EBUSY);
			break;
		}

		if (signal_pending(current)) {
			page = ERR_PTR(-ERESTARTSYS);
			break;
		}

		sgx_reclaim_pages();
		cond_resched();
	}

	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
		wake_up(&ksgxd_waitq);

	return page;
}

Just in case I also checked tip/master, and the result is the same.

/Jarkko
