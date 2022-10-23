Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145B0C3A59D
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Oct 2022 20:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJWUJh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Oct 2022 16:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiJWUJf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 23 Oct 2022 16:09:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97DD18376;
        Sun, 23 Oct 2022 13:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8304CB80B2C;
        Sun, 23 Oct 2022 20:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76F7C433C1;
        Sun, 23 Oct 2022 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666555771;
        bh=Xh170m2MPAycTlCxN9ZIqms5387Ekq3BgBUqfqKYrhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nr1IWUdRABMBmoQ+m1iaGTrw9YBLI9hfnAdHG9l8lGqdwvvh2xMg39U4+u+Tlt8Q7
         I7iaci787L3j7eJ7+3DbxmF5NKLLJfwGLx6vlCmqANegaDo5WQPFuCdEP2WvwzK2tM
         3FEUvRrMOT1ei6n1gy0bDVQFndbGQFZgQaGVKN7W84znZtFen3VG6yK+ltatBHFm5F
         Ayjgjqd0F/HQ7mOQ08xJcRGWAZE/4Sujx54wbE504Izo3wFJAGS2CWcrF6XrOEauaU
         6AVCVe/VQt0VmMngo1KHhFq6lyICM2p65QLQoyrLkx8GPaZW0IUqymhCiYj07E2jQK
         lJHOKMcvPalvQ==
Date:   Sun, 23 Oct 2022 23:09:24 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/5] x86/sgx: use VM_ACCESS_FLAGS
Message-ID: <Y1WfdDBzOUumhJ65@kernel.org>
References: <20221019034945.93081-1-wangkefeng.wang@huawei.com>
 <20221019034945.93081-3-wangkefeng.wang@huawei.com>
 <Y1WfD1x+XDi3xvpL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1WfD1x+XDi3xvpL@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 23, 2022 at 11:07:47PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 19, 2022 at 11:49:42AM +0800, Kefeng Wang wrote:
> > Simplify VM_READ|VM_WRITE|VM_EXEC with VM_ACCESS_FLAGS.
> > 
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 1ec20807de1e..6225c525372d 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -268,7 +268,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
> >  						       unsigned long addr,
> >  						       unsigned long vm_flags)
> >  {
> > -	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
> > +	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
> >  	struct sgx_encl_page *entry;
> >  
> >  	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
> > @@ -502,7 +502,7 @@ static void sgx_vma_open(struct vm_area_struct *vma)
> >  int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> >  		     unsigned long end, unsigned long vm_flags)
> >  {
> > -	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
> > +	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
> >  	struct sgx_encl_page *page;
> >  	unsigned long count = 0;
> >  	int ret = 0;
> > -- 
> > 2.35.3
> > 
> 
> Why?

Only benefit I see is a downside: you have xref VM_ACCESS_FLAGS, which
is counter-productive. Zero gain.

BR, Jarkko
