Return-Path: <SRS0=unfi=R7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34BAC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 19:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BDF21773
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 19:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553799954;
	bh=EEH8dTnxCTdanHSYoH3MoX9k2CQt99gEb+ODNT1Asrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cpGPF9XqXwWM/5kVOeFj4/USh5bCeCkaQljA9OnASc1S0bFZ2UlZTsnoOgW2VlEyi
	 kS7Frsw4hkhjwP0PYgGPArO+kW0q4u1lSKZJ58cVc94+lRtG3HRt7mGLnUw2lOEmFB
	 S8K7P6F3egFla9BE4XZaeTYLsBZCJ91wnuk6DqMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfC1TFy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Mar 2019 15:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfC1TFy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 Mar 2019 15:05:54 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CE6621855
        for <linux-sgx@vger.kernel.org>; Thu, 28 Mar 2019 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553799952;
        bh=EEH8dTnxCTdanHSYoH3MoX9k2CQt99gEb+ODNT1Asrk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U0bAiCF9ZZyKPyZ1u/ZdEkfcLGY1hn5Q9k/64eb0wV1MYABrQez7RwOrXSB07OozK
         /TWAzobk9EsWcEPzN/iUYART5ftaRNBOzLsN812xYDtLm3wbzTwt+ZI71tIovUFQby
         2iWqMPUNBbnWljXtN9xjxNS4sDokqRlW9KFPIRxA=
Received: by mail-wr1-f41.google.com with SMTP id t17so3542991wrw.13
        for <linux-sgx@vger.kernel.org>; Thu, 28 Mar 2019 12:05:52 -0700 (PDT)
X-Gm-Message-State: APjAAAWEvgG2mW0UQf8fejOsWG4Hmhd9CSOpW67AkPHSH1JBwO7NNnPQ
        vBuR3IREjNSetaFNVr4XGwyvuJjp4fsUR0w5ZYhT6A==
X-Google-Smtp-Source: APXvYqzTMupnxcS7aDwFQlxGMsxIzPwFwAagJG+v80mjSa3YQ31zrdPsFBQbS9qa0UiueKDUZnObFkeUHP75aVKy1/w=
X-Received: by 2002:a5d:53d0:: with SMTP id a16mr7709354wrw.309.1553799951095;
 Thu, 28 Mar 2019 12:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com> <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com> <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com> <20190327052830.GF15397@linux.intel.com>
 <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com> <20190327200610.GF9310@linux.intel.com>
 <20190328131939.GI7094@linux.intel.com>
In-Reply-To: <20190328131939.GI7094@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 28 Mar 2019 12:05:39 -0700
X-Gmail-Original-Message-ID: <CALCETrXWMtm9WcPjbYB+ubRkb++WBYzYJAkiU-LJT_SK+m+SmQ@mail.gmail.com>
Message-ID: <CALCETrXWMtm9WcPjbYB+ubRkb++WBYzYJAkiU-LJT_SK+m+SmQ@mail.gmail.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 28, 2019 at 6:19 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, Mar 27, 2019 at 01:06:11PM -0700, Sean Christopherson wrote:
> > I agree with all of the above, but unfortunately blacklisting is really
> > the only benefit that would be realized by modularizing the driver.  The
> > "driver" at this point is just the device and its ioctls, the meat of
> > the functionality has been moved into the subsystem proper.  And the few
> > remaining tidbits of functionality, e.g. sgx_encl_page_alloc() and
> > sgx_encl_alloc(), probably should be moved out of ioctl.c as well.
>
> That is kind of core reason of having an LKM here, to wrap the uapi. It
> is not about reducing size of the kernel. It is about ability to tailor
> the uapi on stock kernels.
>

As I see it, there is really only one significant benefit of modules:
reducing the size of the kernel in the case that the module isn't
loaded.  (And organizing module parameters, I suppose, but you don't,
strictly speaking, need to be able to build as a module to do that.)
SGX can be blacklisted by booting with nosgx (or, if if can't, then
that should be added).

--Andy
