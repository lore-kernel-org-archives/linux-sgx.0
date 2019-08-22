Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F779C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD974233FD
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfHVQ0Q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:26:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:35232 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbfHVQ0Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:26:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:26:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="196282545"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga001.fm.intel.com with ESMTP; 22 Aug 2019 09:26:13 -0700
Message-ID: <25592922b1bfe6f522d9e49b649e4a07e1db1890.camel@linux.intel.com>
Subject: Re: [PATCH 3/5] x86/sgx: Make sgx_validate_secinfo() more readable
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Date:   Thu, 22 Aug 2019 19:26:12 +0300
In-Reply-To: <20190822034823.GU29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-4-jarkko.sakkinen@linux.intel.com>
         <20190822034823.GU29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 20:48 -0700, Sean Christopherson wrote:
> > +	if ((page_type != SGX_SECINFO_REG &&
> > +	     page_type != SGX_SECINFO_TCS &&
> > +	     page_type != SGX_SECINFO_TRIM))
> 
> Shouldn't we disallow TRIM until SGX2 is supported?

Yes.

I squashed the change with TRIM removed.

I also renamed the local variable page_type as pt. I think that is
a good abbrevation for page type and saves some screen space.

/Jarkko

