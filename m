Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8FCC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C0C207FC
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LDoeI3L5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404772AbgFYRbT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 13:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404698AbgFYRbT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Jun 2020 13:31:19 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A32C08C5C1;
        Thu, 25 Jun 2020 10:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GCepHJh9IvbGOEQER27ddp06egUGwt041SLYlZAWLGQ=; b=LDoeI3L5sL64qfTFZFbfaFhX/j
        0+0LzH5jw1ocXadxpn1oRN2Um70u4pffz79BOnas1937BaA+AtbBkQyW+QqLZOkK1LAftXyTojsVJ
        Tsw3QmjN0k4vt+tbj8Wow5n96aciCp9QP8tdyv1S2x2lydDNyBMc2a3giXkzhYzkqVeSq9T2bCiah
        YRbE3EwQrKkqXkLioWoo18nE3hCLaAr3ggQChuy91sk3yksfpFhaO57VgLOjnflw9MDRM2QMhGUSy
        D9Qc5V6MPeZIjXqFap2i6TRu3MkW7t0Y8u4tGe9yoSIkqBUWoW//Cz2M5yzQguhun7ezsJ62rmYE9
        y4pNw5WA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joVi6-00020t-Ru; Thu, 25 Jun 2020 17:30:50 +0000
Date:   Thu, 25 Jun 2020 18:30:50 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH v33 10/21] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20200625173050.GF7703@casper.infradead.org>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-11-jarkko.sakkinen@linux.intel.com>
 <20200625171416.GI20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625171416.GI20319@zn.tnic>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 07:14:16PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:32AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Something ate the Cc:s. Lemme add the mm list, akpm is already on Cc.
> 
> Leaving in the rest for mm folks.

Thanks!

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index dc7b87310c10..be40b9c29327 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -542,6 +542,8 @@ struct vm_operations_struct {
> >  	void (*close)(struct vm_area_struct * area);
> >  	int (*split)(struct vm_area_struct * area, unsigned long addr);
> >  	int (*mremap)(struct vm_area_struct * area);
> > +	int (*may_mprotect)(struct vm_area_struct *vma, unsigned long start,
> > +			    unsigned long end, unsigned long prot);

This is unlike any other vm operation.  Every other one is a verb.

> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index ce8b8a5eacbb..f7731dc13ff0 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -603,13 +603,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> >  			goto out;
> >  		}
> >  
> > +		tmp = vma->vm_end;
> > +		if (tmp > end)
> > +			tmp = end;
> > +
> > +		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
> > +			error = vma->vm_ops->may_mprotect(vma, nstart, tmp,
> > +							  prot);
> > +			if (error)
> > +				goto out;
> > +		}
> > +
> >  		error = security_file_mprotect(vma, reqprot, prot);
> >  		if (error)
> >  			goto out;
> >  

I think the right way to do this is:

                error = security_file_mprotect(vma, reqprot, prot);
                if (error)
                        goto out;

                tmp = vma->vm_end;
                if (tmp > end)
                        tmp = end;
+		if (vma->vm_ops->mprotect)
+			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp,
+					newflags);
+		else
+			error = mprotect_fixup(vma, &prev, nstart, tmp,
+					newflags);
-               error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
                if (error)
                        goto out;

and then the vma owner can do whatever it needs to before calling
mprotect_fixup(), which is already not static.

(how did we get to v33 with this kind of problem still in the patch set?)
