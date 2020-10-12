Return-Path: <SRS0=8JFI=DT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C91C433E7
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Oct 2020 16:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB0520878
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Oct 2020 16:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403791AbgJLQvL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:51:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:25720 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403778AbgJLQvL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Oct 2020 12:51:11 -0400
IronPort-SDR: nY42OOrW8chaxgnwBnIk8k1XjiDNXdqjm/zkcHbilZQBbsif5IG+SdsHWfBZ6Wax4R+lYvUdo+
 Kxe9Cdnf0sjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="164985053"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="164985053"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:51:08 -0700
IronPort-SDR: tSLYrDYHK7fbzX4zjazH/J4S8MUExl9kkpOfCYw+SomYDqq5ugNWk4t0AD3iIZCusG32CA9od5
 5LrCcEXvhU+Q==
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="530042114"
Received: from lohmeies-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.19])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:50:55 -0700
Date:   Mon, 12 Oct 2020 19:50:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 22/24] selftests/x86: Add a selftest for SGX
Message-ID: <20201012165051.GA8475@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-23-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003045059.665934-23-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 07:50:57AM +0300, Jarkko Sakkinen wrote:
> Add a selftest for SGX. It is a trivial test where a simple enclave
> copies one 64-bit word of memory between two memory locations.
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Greg, speaking of dual licensing, I'd make an expection with this
selftest to what we agreed in the last week.

It's the only compact C-only example that I'm aware of that shows how to
put together the basics of an SGX user space. Here a more permissive
licensing would make sense in my opinion just to give a seed for
alternatives.

Right now the user space implementations are either in C++ and Rust, and
they work great for big things like containers etc. I could envision
someone to have something more minimalistic to do something simple for
lets say a system daemon.

I've done a similar decision with tools/testing/selftests/tpm2/tpm2.py
in the past.

What do you think?

/Jarkko
