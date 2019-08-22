Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D2AC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C837C233A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732378AbfHVOpX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:45:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:61825 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbfHVOpX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 10:45:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 07:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="208191565"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga002.fm.intel.com with ESMTP; 22 Aug 2019 07:45:21 -0700
Message-ID: <53356fc2b00d322f599a92a07d1ce83a66dc4df4.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] x86/sgx: Remove duplicate check for entry->epc_page
 in sgx_encl_load_page()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Date:   Thu, 22 Aug 2019 17:45:20 +0300
In-Reply-To: <20190822003358.GO29345@linux.intel.com>
References: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
         <20190821232902.29476-2-jarkko.sakkinen@linux.intel.com>
         <20190822003358.GO29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 17:33 -0700, Sean Christopherson wrote:
> On Thu, Aug 22, 2019 at 02:29:01AM +0300, Jarkko Sakkinen wrote:
> > The existence of the page is checked first hand for legit race
> > conditions (either two or more concurrent threads running the #PF
> > handler or the reclaimer has taken over the page):
> > 
> > /* Page is already resident in the EPC. */
> > if (entry->epc_page) {
> > 	if (entry->desc & SGX_ENCL_PAGE_RECLAIMED)
> > 		return ERR_PTR(-EBUSY);
> > 
> > 	return entry;
> > }
> > 
> > After that the existence is a checked as a condition for ELDU.
> > 
> > This commit removes the redundant check.
> > 
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> 
> Ha, I remember seeing this a while back and completely forgot about it.
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

[I guess for this ack-by would be appropriate as they are not mainline
patches]

Thanks Sean. These kind of regression are almost unavoidable because of
heavy rebasing...

/Jarkko

