Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14789C0650F
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 18:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5E992171F
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 18:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfHHSD4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 14:03:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:53128 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730170AbfHHSD4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 14:03:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 11:03:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="169068019"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 08 Aug 2019 11:03:55 -0700
Date:   Thu, 8 Aug 2019 11:03:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 11/11] x86/sgx: Shrink the enclave if
 ECREATE/EADD fails
Message-ID: <20190808180355.GG23156@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-12-sean.j.christopherson@intel.com>
 <20190808155008.i3ll4dglbc7qmqvn@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808155008.i3ll4dglbc7qmqvn@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 08, 2019 at 06:50:08PM +0300, Jarkko Sakkinen wrote:
> On Wed, Aug 07, 2019 at 05:12:54PM -0700, Sean Christopherson wrote:
> > Add sgx_encl_shrink() to pair with sgx_encl_grow() and use it to adjust
> > the VA page count when ECREATE or EADD fails.  Return the allocated VA
> > page from sgx_encl_grow() so that it can be freed during shrink.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This missed wrapping -ENOMEM with ERR_PTR() when va_page alloation fails.
Let me know if you want me to send a v2 or if you'll fix it up when
applying.
