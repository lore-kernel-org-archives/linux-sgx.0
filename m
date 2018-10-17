Return-Path: <SRS0=78qm=M5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69927ECDE3E
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Oct 2018 23:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D7621470
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Oct 2018 23:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33D7621470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbeJRHnp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Oct 2018 03:43:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:18151 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbeJRHno (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Oct 2018 03:43:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2018 16:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,393,1534834800"; 
   d="scan'208";a="82066623"
Received: from unknown (HELO jsakkine-mobl1) ([10.249.254.40])
  by orsmga007.jf.intel.com with ESMTP; 17 Oct 2018 16:45:28 -0700
Date:   Thu, 18 Oct 2018 02:45:27 +0300 (EEST)
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
In-Reply-To: <20181015205436.GA28500@amd>
Message-ID: <alpine.DEB.2.21.1810180205490.5022@jsakkine-mobl1>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com> <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com> <20181015205436.GA28500@amd>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181017234527.MZaOEPWDM66VekQ531K5-CJVxRcNKgKBKb2KYiA0F2k@z>

On Mon, 15 Oct 2018, Pavel Machek wrote:
> On Tue 2018-09-25 16:06:56, Jarkko Sakkinen wrote:
>> +Intel(R) SGX is a set of CPU instructions that can be used by applications to
>> +set aside private regions of code and data. The code outside the enclave is
>> +disallowed to access the memory inside the enclave by the CPU access control.
>> +In a way you can think that SGX provides inverted sandbox. It protects the
>> +application from a malicious host.
>
> Well, recently hardware had some problems keeping its
> promises. So... what about rowhammer, meltdown and spectre?

Doesn't hardware always have this problem over time?

> Which ones apply, which ones do not, and on what cpu generations?

Definitely should be refined.

Meltdowns approach AFAIK does not work because reads outside the enclave
will always have a predefined value (-1) but only if the page is present,
which was later exploited in the Foreshadow attack.

> Encryption, that sounds nice, but it is hard to do right. If SGX
> protected code changes single bit in its memory, how many bits will be
> changed in physical RAM?

512-bit blocks and merkle tree based mac. It is pretty well documented
in https://eprint.iacr.org/2016/204.pdf. I'll take not to myself to add
this to the references.

Thanks for the feedback. The ocumentation is hard to drive forward w/o it.

/Jarkko
