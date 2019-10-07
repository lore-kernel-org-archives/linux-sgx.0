Return-Path: <SRS0=s70M=YA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A34AECE58C
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 12:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2A622173B
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 12:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfJGMEY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Oct 2019 08:04:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:41701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfJGMEY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 7 Oct 2019 08:04:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 05:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="186965410"
Received: from bplackle-mobl.ger.corp.intel.com (HELO localhost) ([10.252.6.229])
  by orsmga008.jf.intel.com with ESMTP; 07 Oct 2019 05:04:13 -0700
Date:   Mon, 7 Oct 2019 15:04:12 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v22 16/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20191007120412.GB20830@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
 <20191002231804.GA14315@linux.intel.com>
 <20191004001459.GD14325@linux.intel.com>
 <20191004185221.GI6945@linux.intel.com>
 <20191005155412.GA9159@linux.intel.com>
 <20191007075712.GA5466@linux.intel.com>
 <20191007081024.GA5962@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007081024.GA5962@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 11:10:24AM +0300, Jarkko Sakkinen wrote:
> Actually, maybe like this:
> 
> struct sgx_enclave_add_page_desc {
> 	__u64	addr;
> 	__u64	offset;
> 	__u64	secinfo;
> 	__u16	mrmask;
> 	__u8	reserved[6];
> };
> 
> struct sgx_enclave_add_page {
> 	__u64	src;
> 	__u64	nr_pages;
> 	__u64	pages;
> };

Of course we should remove @addr:

struct sgx_enclave_add_page_desc {
	__u64	offset;
	__u16	mrmask;
	__u8	reserved[6];
};

struct sgx_enclave_add_page {
	__u64	src;
	__u64	secinfo;
	__u64	nr_pages;
	__u64	pages;
};

That is something we have forgot to do. We should have started to use
offset instead of address when we moved to fd based API. Anyway I think
this kind of API where you give array of descriptors from one source
would be optimal.

Also, @secinfo is better to be out of the descriptor so that let say
LSM checks could be done with a single callback.

/Jarkko
