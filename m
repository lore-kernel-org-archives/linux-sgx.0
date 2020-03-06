Return-Path: <SRS0=xE7g=4X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C42C10F00
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Mar 2020 18:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 849E1206D5
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Mar 2020 18:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCFS6M (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:58:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:23448 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgCFS6M (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Mar 2020 13:58:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 10:58:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,523,1574150400"; 
   d="scan'208";a="234890111"
Received: from wbakowsk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.27.142])
  by orsmga008.jf.intel.com with ESMTP; 06 Mar 2020 10:58:05 -0800
Date:   Fri, 6 Mar 2020 20:58:04 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>
Subject: Re: [PATCH v28 11/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200306185804.GE7472@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-12-jarkko.sakkinen@linux.intel.com>
 <20200305174015.GJ11500@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305174015.GJ11500@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 05, 2020 at 09:40:15AM -0800, Sean Christopherson wrote:
> Would it make sense to add reserved fields to the structs so that new
> features can be added in a backwards compatible way?  E.g. if we want to
> allow userspace to control the backing store by passing in a file
> descriptor ENCLAVE_CREATE.

It would not really be a huge win even if you did that since old
software would not be aware of the new fields. Sounds somewhat
messy to me.

Even a new ioctl later on is in my opinion always a better option
than reserved fields when you add ioctl's.

/Jarkko
