Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD8CC433FF
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F1A2086A
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405611AbfHIQNz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 12:13:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:9693 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfHIQNz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 12:13:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 09:13:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,364,1559545200"; 
   d="scan'208";a="259081520"
Received: from ishiri-mobl1.ger.corp.intel.com ([10.252.50.117])
  by orsmga001.jf.intel.com with ESMTP; 09 Aug 2019 09:13:51 -0700
Message-ID: <42e2fc895c22f0619c3af6313831891e975106f3.camel@linux.intel.com>
Subject: Re: [PATCH for_v22 11/11] x86/sgx: Shrink the enclave if
 ECREATE/EADD fails
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Date:   Fri, 09 Aug 2019 19:13:50 +0300
In-Reply-To: <20190808180355.GG23156@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
         <20190808001254.11926-12-sean.j.christopherson@intel.com>
         <20190808155008.i3ll4dglbc7qmqvn@linux.intel.com>
         <20190808180355.GG23156@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-08 at 11:03 -0700, Sean Christopherson wrote:
> On Thu, Aug 08, 2019 at 06:50:08PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Aug 07, 2019 at 05:12:54PM -0700, Sean Christopherson wrote:
> > > Add sgx_encl_shrink() to pair with sgx_encl_grow() and use it to adjust
> > > the VA page count when ECREATE or EADD fails.  Return the allocated VA
> > > page from sgx_encl_grow() so that it can be freed during shrink.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> This missed wrapping -ENOMEM with ERR_PTR() when va_page alloation fails.
> Let me know if you want me to send a v2 or if you'll fix it up when
> applying.

I can fix it, no problem.

/Jarkko

