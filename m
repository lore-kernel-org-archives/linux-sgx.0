Return-Path: <SRS0=mvcT=W2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BA6C3A59F
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05DC421670
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfH3ACw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:02:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:23770 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfH3ACw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 20:02:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:02:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="175435402"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 29 Aug 2019 17:02:51 -0700
Date:   Thu, 29 Aug 2019 17:02:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2 1/5] x86/sgx: Convert encl->flags from an unsigned int
 to an atomic
Message-ID: <20190830000251.GB27970@linux.intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
 <20190827192717.27312-2-sean.j.christopherson@intel.com>
 <20190829000600.jkk7aih7j4cwzejp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829000600.jkk7aih7j4cwzejp@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 29, 2019 at 04:09:29PM +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 27, 2019 at 12:27:13PM -0700, Sean Christopherson wrote:
> > @@ -77,7 +78,7 @@ static int sgx_release(struct inode *inode, struct file *file)
> >  	};
> >  
> >  	mutex_lock(&encl->lock);
> > -	encl->flags |= SGX_ENCL_DEAD;
> > +	atomic_or(SGX_ENCL_DEAD, &encl->flags);
> >  	mutex_unlock(&encl->lock);
> 
> Had a couple of checkpatch.pl errors (not a biggie, just a remark).

Regarding the checkpatch warnings, I intentionally ignored these:

WARNING: line over 80 characters
#181: FILE: arch/x86/kernel/cpu/sgx/ioctl.c:547:
+       if (atomic_read(&encl->flags) & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {

WARNING: line over 80 characters
#248: FILE: arch/x86/kernel/cpu/sgx/reclaim.c:386:
+           (atomic_read(&encl->flags) & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED)))

total: 0 errors, 2 warnings, 181 lines checked


The one in ioctl.c is ephemeral, i.e. won't exist once the whole series is
squashed, and I felt the code in reclaim.c was more readable by letting
the line poke out a few chars.

That being said, I definitely don't care if you want to tweak the code to
eliminate the warning.
