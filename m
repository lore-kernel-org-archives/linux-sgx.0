Return-Path: <SRS0=mh0A=NA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342E1ECDE43
	for <linux-sgx@archiver.kernel.org>; Sat, 20 Oct 2018 00:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDBDA21486
	for <linux-sgx@archiver.kernel.org>; Sat, 20 Oct 2018 00:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDBDA21486
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbeJTIIW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 20 Oct 2018 04:08:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:30884 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbeJTIIV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 20 Oct 2018 04:08:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Oct 2018 17:00:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,401,1534834800"; 
   d="scan'208";a="82918970"
Received: from kskibin-mobl.ger.corp.intel.com ([10.249.254.29])
  by orsmga008.jf.intel.com with ESMTP; 19 Oct 2018 16:59:59 -0700
Date:   Sat, 20 Oct 2018 02:59:57 +0300 (EEST)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-X-Sender: jsakkine@jsakkine-mobl1
To:     Pavel Machek <pavel@ucw.cz>
cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
In-Reply-To: <20181018095727.GC10861@amd>
Message-ID: <alpine.DEB.2.21.1810200235290.9963@jsakkine-mobl1>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com> <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com> <20181015205436.GA28500@amd> <alpine.DEB.2.21.1810180205490.5022@jsakkine-mobl1> <20181018095727.GC10861@amd>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181019235957.l_amwC2FQbuknG9MQgk2Y1t3k5NP8QcQ3cRlz9w2wOg@z>

On Thu, 18 Oct 2018, Pavel Machek wrote:
>> Definitely should be refined.
>>
>> Meltdowns approach AFAIK does not work because reads outside the enclave
>> will always have a predefined value (-1) but only if the page is present,
>> which was later exploited in the Foreshadow attack.
>
> What about L1tf and https://github.com/lsds/spectre-attack-sgx ?

L1TF is the vuln and Foreshadow is the attack taking advantage of the
vuln. I didn't mean to patch the documention in my response or give
extensive list of the vulns if you expected that.

For kernel documentation it does make sense to give a threat model
but not enumerate every possible vuln.

/Jarkko
