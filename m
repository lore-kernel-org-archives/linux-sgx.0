Return-Path: <SRS0=WnBG=N7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EF2C43441
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Nov 2018 11:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0434B20685
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Nov 2018 11:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0434B20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbeKTV3G (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Nov 2018 16:29:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:27486 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbeKTV3G (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 20 Nov 2018 16:29:06 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2018 03:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,256,1539673200"; 
   d="scan'208";a="107788267"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.177])
  by fmsmga004.fm.intel.com with ESMTP; 20 Nov 2018 03:00:27 -0800
Date:   Tue, 20 Nov 2018 13:00:27 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181120110027.GB14594@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <20181119150655.GA11843@linux.intel.com>
 <e8e640be-6f9f-0835-0578-48f140ac68f9@fortanix.com>
 <20181119171934.GA16252@linux.intel.com>
 <2804DD93-E67B-4E06-800D-82A2EA21FCC9@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2804DD93-E67B-4E06-800D-82A2EA21FCC9@amacapital.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 19, 2018 at 11:18:54AM -0700, Andy Lutomirski wrote:
> Once static_call lands, this will be a great use for it.

When is it expected to land? Cool feature BTW!

/Jarkko
