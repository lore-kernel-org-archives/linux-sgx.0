Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C66C48BDF
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 00:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3ABC611CE
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 00:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhFPAcP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Jun 2021 20:32:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:62112 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhFPAcO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Jun 2021 20:32:14 -0400
IronPort-SDR: qT64UeE3pFaKm0U+GpCDUW+unrWRS4U7vUpETAODAwrhi/VLffZWY2632k1a50ONVN70HYnLyQ
 7mC38W0IUkMg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="203069507"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="203069507"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 17:30:09 -0700
IronPort-SDR: fmGfdqiVe+U/QyOTHgXczvJh9eHrIAS4EhRhahki1tTo3jrh235h3Db6/CvdsfPNUwFWEnIEtu
 T7jjSxkRot3w==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="621519780"
Received: from shyvonen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.5.121])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 17:30:06 -0700
Message-ID: <618b42d66a4f2087ef4c54cc50fd56d01233eab1.camel@intel.com>
Subject: Re: [PATCH] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Date:   Wed, 16 Jun 2021 12:30:04 +1200
In-Reply-To: <20210615132001.kd6cuktq37dvoq3l@kernel.org>
References: <20210615101639.291929-1-kai.huang@intel.com>
         <20210615132001.kd6cuktq37dvoq3l@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-06-15 at 16:20 +0300, Jarkko Sakkinen wrote:
> On Tue, Jun 15, 2021 at 10:16:39PM +1200, Kai Huang wrote:
> > xa_destroy() needs to be called to destroy virtual EPC's page arra
>                                                                     y
> 
> > before calling kfree() to free the virtual EPC.  Currently it is not
> > calaled.  Add the missing xa_destroy() to fix.
>   called

Thanks Jarkko. I literally need to find some way to avoid such error in future :)

> 
> > Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM guests")
> > Tested-by: Yang Zhong <yang.zhong@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/virt.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> > index 6ad165a5c0cc..64511c4a5200 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -212,6 +212,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
> >  		list_splice_tail(&secs_pages, &zombie_secs_pages);
> >  	mutex_unlock(&zombie_secs_pages_lock);
> >  
> > +	xa_destroy(&vepc->page_array);
> >  	kfree(vepc);
> >  
> >  	return 0;
> > -- 
> > 2.31.1
> > 
> > 
> 
> /Jarkko


