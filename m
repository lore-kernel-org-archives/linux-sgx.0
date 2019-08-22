Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E63CC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366082053B
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390153AbfHVQpM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:45:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:45742 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390140AbfHVQpL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:45:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:45:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="169842603"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 09:45:06 -0700
Message-ID: <96b1dc844a4f819ce1a8a7a9ce6bb112ba0e4159.camel@linux.intel.com>
Subject: Re: [PATCH 3/5] x86/sgx: Make sgx_validate_secinfo() more readable
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Ayoun, Serge" <serge.ayoun@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christpherson@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>
Date:   Thu, 22 Aug 2019 19:45:05 +0300
In-Reply-To: <88B7642769729B409B4A93D7C5E0C5E7C661E682@hasmsx108.ger.corp.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-4-jarkko.sakkinen@linux.intel.com>
         <88B7642769729B409B4A93D7C5E0C5E7C661E682@hasmsx108.ger.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 10:39 +0000, Ayoun, Serge wrote:
> > +	if ((page_type != SGX_SECINFO_REG &&
> > +	     page_type != SGX_SECINFO_TCS &&
> > +	     page_type != SGX_SECINFO_TRIM))
> > +		return -EINVAL;
> 
> sgx_validate_secinfo() is called via eadd ioctl. Eadd will fail with
> TRIM page type, so you probably need to remove it from the if
> sgx2.0 does not change this behavior

Thanks! Removed.

/Jarkko

