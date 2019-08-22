Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4150C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 838CB206B7
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbfHVQFJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:05:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:57299 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbfHVQFJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:05:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:05:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="262908226"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2019 09:05:04 -0700
Message-ID: <ecd780e9269abb09120cadafafc4c67c81cefe30.camel@linux.intel.com>
Subject: Re: [PATCH 1/5] x86/sgx: Document permission handling better
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Date:   Thu, 22 Aug 2019 19:04:53 +0300
In-Reply-To: <20190822034356.GS29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-2-jarkko.sakkinen@linux.intel.com>
         <20190822034356.GS29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 20:43 -0700, Sean Christopherson wrote:
> > -	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
> > +	/* TCS pages must always RW set for CPU access while the SECINFO
> 
> Should be
> 
> 	/*
> 	 * TCS pages ...
> 
> > +	 * permissions are *always* zero - the CPU ignores the user provided
> > +	 * values and silently overwrites zero permissions.
> 
> Maybe 'overwrites with zero permissions'?

I squashed this with the proposed changes made. Thank you.

/Jarkko

