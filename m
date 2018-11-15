Return-Path: <SRS0=gtji=N2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E630FC43441
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Nov 2018 20:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B74D52086C
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Nov 2018 20:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B74D52086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbeKPGn1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 01:43:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:10130 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbeKPGn1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 01:43:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2018 12:34:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,237,1539673200"; 
   d="scan'208";a="281459393"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.140])
  by fmsmga006.fm.intel.com with ESMTP; 15 Nov 2018 12:33:57 -0800
Date:   Thu, 15 Nov 2018 22:33:56 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, Shuah Khan <shuah@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dmitry Safonov <dima@arista.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH RFC] selftests/x86: Add a selftest for SGX
Message-ID: <20181115203356.GC26875@linux.intel.com>
References: <20181113214038.16136-1-jarkko.sakkinen@linux.intel.com>
 <ace87d75-2ba0-38f6-0a77-25d45b692d7d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ace87d75-2ba0-38f6-0a77-25d45b692d7d@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 13, 2018 at 01:51:06PM -0800, Dave Hansen wrote:
> On 11/13/18 1:40 PM, Jarkko Sakkinen wrote:
> > +int main(int argc, char **argv)
> > +{
> > +	unsigned long bin_size = (unsigned long)&encl_bin_end -
> > +				 (unsigned long)&encl_bin;
> > +	struct sgx_secs secs;
> > +	uint64_t result = 0;
> > +
> > +	if (!encl_load(&secs, bin_size))
> > +		exit(1);
> > +
> > +	sgx_call((void *)&MAGIC, &result, (void *)secs.base);
> > +	if (result != MAGIC) {
> > +		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
> > +		exit(1);
> > +	}
> > +
> > +	exit(0);
> > +}
> 
> Well, I guess 100 lines of code for something a wee bit shy of hello
> world isn't bad. :)
> 
> In general, this looks fine, but probably needs some better commenting
> and probably some messages that make it a bit more clear what is going on.
> 
> It would be _nice_, for instance to try to do some CPUID detection of
> SGX so that the error (or success?) message can tell you whether you're
> missing hardware support or kernel support.
> 
> Thanks for doing this, though.  It's sorely needed.

Great, thanks, I see what I can do.

/Jarkko
