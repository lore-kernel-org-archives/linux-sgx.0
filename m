Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7BAC31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 12:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C54C6208CB
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 12:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbfFSMYf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:24:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:65156 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731731AbfFSMYf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 08:24:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 05:24:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="165010595"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by orsmga006.jf.intel.com with ESMTP; 19 Jun 2019 05:24:32 -0700
Message-ID: <c0b82ee1fef7635181e8f513d489524f41e57358.camel@linux.intel.com>
Subject: Re: [PATCH RFC] x86/sgx: Check that the address is within ELRANGE
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>
Date:   Wed, 19 Jun 2019 15:24:29 +0300
In-Reply-To: <20190617223029.GB30158@linux.intel.com>
References: <20190613164240.31326-1-jarkko.sakkinen@linux.intel.com>
         <20190617223029.GB30158@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-06-17 at 15:30 -0700, Sean Christopherson wrote:
> On Thu, Jun 13, 2019 at 07:42:40PM +0300, Jarkko Sakkinen wrote:
> > In sgx_encl_page_alloc() check that the given address within the
> > ELRANGE. Return -EINVAL if not.
> > 
> > Reported-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > index d17c60dca114..9d3fc770b4d9 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > @@ -240,19 +240,26 @@ static struct sgx_encl_page
> > *sgx_encl_page_alloc(struct sgx_encl *encl,
> >  	struct sgx_encl_page *encl_page;
> >  	int ret;
> >  
> > +	if (addr < encl->base || addr > (encl->base + encl->size))
> 
> The upper bounds check should be "addr >= (encl->base + encl->size)" or
> "addr > (encl->base + encl->size - 1)"

Right, thanks :-) Shay told me that this did not happen with earlier
patch set versions but I could not spot why. Have to look again
before merging.

/Jarkko

