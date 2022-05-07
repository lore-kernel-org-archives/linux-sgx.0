Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB4EC433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  7 May 2022 18:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385126AbiEGSEA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 7 May 2022 14:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446750AbiEGSDt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 7 May 2022 14:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217B72CE11
        for <linux-sgx@vger.kernel.org>; Sat,  7 May 2022 11:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB1661377
        for <linux-sgx@vger.kernel.org>; Sat,  7 May 2022 18:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D74AC385A6;
        Sat,  7 May 2022 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651946401;
        bh=hUedcR4FRCenOSNB5YR+69Jo7axel56BTfFdTmBTpCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SL/U/Ihzv6b8GR/gGyRHmHfibPxoO2+tKwkN34O+v0ESD+p8LGcFBHxYyHOpLfBSx
         kW1zT8u+Si1Zmy7qWAzZGR/5XTnFeLBHWWEK0mP/1ked+1LkwgEFDrISOhS83RUDVz
         X8bwIsRcEklQRqX/EIVfT6PjnnjHr181yZgnk9uWy9/GMMwo6q4iiDY7J4JQwXqqxB
         5HKPGDhYrOg1re/Fqy2Ey+uCiQJsoQFAR4JkSfrVdTr0v2Rx8Sl8Chv9SvGCijiq/Z
         ATl8Wz4vGFUOVi4jmTcFSI9+nM1oHOh0PUB3DBfpfEOln63MGZbY8KQTV4ds8nRvFd
         cx2jrTtLcgeyQ==
Date:   Sat, 7 May 2022 21:01:35 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [RFC PATCH 2/4] x86/sgx: Set dirty bit after modifying page
 contents
Message-ID: <Ynaz/0PBWfyPZfPI@kernel.org>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
 <de2e1a1d69331bb521222eb93b5ffa6d00af354c.camel@kernel.org>
 <0689f89d-2025-477a-32ab-eebd4090341b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0689f89d-2025-477a-32ab-eebd4090341b@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 06, 2022 at 03:40:26PM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 5/6/2022 3:27 PM, Jarkko Sakkinen wrote:
> > On Thu, 2022-04-28 at 13:11 -0700, Reinette Chatre wrote:
> >> Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
> >> after faulting the enclave page") expanded __sgx_encl_eldu()
> >> to clear an enclave page's PCMD (Paging Crypto MetaData)
> >> from the PCMD page in the backing store after the enclave
> >> page is restored to the enclave.
> >>
> >> Since the PCMD page in the backing store is modified the page
> >> should be set as dirty when releasing the reference to
> >> ensure the modified data is retained.
> >>
> >> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
> >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> >> ---
> >>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> >> index e5d2661800ac..e03f124ce772 100644
> >> --- a/arch/x86/kernel/cpu/sgx/encl.c
> >> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> >> @@ -98,7 +98,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >>         kunmap_atomic(pcmd_page);
> >>         kunmap_atomic((void *)(unsigned long)pginfo.contents);
> >>  
> >> -       sgx_encl_put_backing(&b, false);
> >> +       sgx_encl_put_backing(&b, true);
> >>  
> >>         sgx_encl_truncate_backing_page(encl, page_index);
> >>  
> > 
> > So, the implementation is:
> > 
> > void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
> > {
> > 	if (do_write) {
> > 		set_page_dirty(backing->pcmd);
> > 		set_page_dirty(backing->contents);
> > 	}
> > 
> > 	put_page(backing->pcmd);
> > 	put_page(backing->contents);
> > }
> > 
> > And we only want to set dirty for PCMD part, right?
> > 
> > Thus, perhaps we should fix it instead by:
> > 
> > 	set_page_dirty(backing->pcmd);
> > 	put_page(backing->pcmd):
> > 	put_page(backing->contents);
> > 	
> > ?	
> > 
> > I would not mind getting rid of that function anyway. It's kind
> > of bad wrapping IMHO.
> 
> Could we rather just change sgx_encl_put_backing() to be:
> 
> void sgx_encl_put_backing(struct sgx_backing *backing)
> {
> 	put_page(backing->pcmd);
> 	put_page(backing->contents);
> }
> 
> Two reasons:
> 
> 1) Instead of getting rid of sgx_encl_put_backing() we can keep
>    it so that its name reflects its work and its usage remains
>    symmetrical to sgx_encl_get_backing() that will stay and
>    the code thus continues to be clear on the page references.
> 
> 2) By moving the set_page_dirty() out of that function the
>    set_page_dirty() can be called _before_ writing data to
>    the page, which is the right thing to do per:
>    https://lore.kernel.org/linux-sgx/c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com/


Yes, this does make sense to me. Important bit was to refactor
set_page_dirty() calls out but for sure put_page()'s can still
be wrapped.

As I responded to Dave just few moments ago, one option would be
*possibly* to do the truncation part in ksgxd but I hope we hope
we don't have to go to that because it would mean also extra
book-keeping...

Took a bit of effort but I finally got this reproduced with my
laptop with this CPU:

Intel(R) Core(TM) i7-1065G7 CPU @ 1.30GHz

That's why I've had some radio silence in the meanwhile. In other
words, I should be now able to also to test the fix locally.

PS. I'm sorry if I've double-replied to this. Was not sure if
my first response left yesterday, and could not find it from
lore (and this does contain anyway stuff that was not incldued
into that).

BR, Jarkko
