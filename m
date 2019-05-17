Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3634BC04E87
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 046182168B
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558116283;
	bh=VajmFIi4cuLIvqMkyBZ/ftEaIqnCUIfCR3EwyJx4A1Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xvDunWS1PByKbe0JAjG/CBFVux1RwY/8abPaLDQrCswVqmCE0UuhCEO2LUPyGUYji
	 oiJ03izl5ZdUIIKOEOgVnUgYPLxuEEB4C/y1LKNyH2xxHnwhTqFM/zU4q5zNnL0Dqf
	 yl9DdUpX3lqw4FSnbZFEXOf6ztBKpmAn6EwpL7I0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfEQSEm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:04:42 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33508 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfEQSEm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 14:04:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id x132so5985171lfd.0
        for <linux-sgx@vger.kernel.org>; Fri, 17 May 2019 11:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GqLsKGWePcHeYkjL6WcpBkvnp3m99gvexZby0QRo7VY=;
        b=FLSkmQlUFMZbLyvTJKsJsbzUTzwJ007awR+MJFBzBBIfeyUsLSpio9pw1egk8rl+1T
         GED5nIz0MTZm4wj6hHTQGkolwiBKx+3k5poKvYAAORvXGNs8I19OUvhU2aPU09ae6kVb
         04zIZrSmhGYDYVb200BkHqJrTSJZ0aDJZNgqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqLsKGWePcHeYkjL6WcpBkvnp3m99gvexZby0QRo7VY=;
        b=WU3e+RSflgvLHy4II2gEnpiDM4tlsfFh+VDg+jwngSA4UIhSqyaH+8PBof6fXBv803
         bSRL9wAPgN9IlOW+Quga1nAwleVXHiWq4FCtJ0gzw8FwNsReI8J3it8x3jq4j5GQnWwy
         6cGk0ZSYDJsVPCa1pyloU1Kp5eu66kENDL8UgC6HgZDiB9hpWQqRkpBMeEaHpmzq7+Bp
         P5n6iLvJzyvV+mLNb4SH0OmE7DGcHeP5wMsaLzxEYUp9NzLI8OFE6EMLom8ovvi6A9qo
         QsYWTtorWCQ/um3MnT4s+BUBCvy67sJAChUAVoMbjkQGnFAXzitpXWR8mIGNRuo/0ni8
         2zUw==
X-Gm-Message-State: APjAAAXiOZkRFV2KJBe23K/gd7AvXRufCdJT8F+lnf27cuodhxDasomm
        mj8t1Hk6p3HMOVItIPi4ZRYjoFZCbYY=
X-Google-Smtp-Source: APXvYqyQA16B/q7oO2YUvX5Z9rpDHxcj6juiKcbIQO/VfSPLgatTnNz3j+cAfKwt4uPwkLWYxPxeRw==
X-Received: by 2002:ac2:5a1b:: with SMTP id q27mr24242709lfn.63.1558116280378;
        Fri, 17 May 2019 11:04:40 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id d2sm536849ljc.84.2019.05.17.11.04.39
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 11:04:39 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id y13so5942940lfh.9
        for <linux-sgx@vger.kernel.org>; Fri, 17 May 2019 11:04:39 -0700 (PDT)
X-Received: by 2002:ac2:59c7:: with SMTP id x7mr24467304lfn.75.1558116278802;
 Fri, 17 May 2019 11:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov> <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov> <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <20190517172953.GC15006@linux.intel.com> <DFE03E0C-694A-4289-B416-29CDC2644F94@amacapital.net>
 <20190517175500.GE15006@linux.intel.com>
In-Reply-To: <20190517175500.GE15006@linux.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 May 2019 11:04:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com>
Message-ID: <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 10:55 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> In this snippet, IS_PRIVATE() is true for anon inodes, false for
> /dev/sgx/enclave.  Because EPC memory is always shared, SELinux will never
> check PROCESS__EXECMEM for mprotect() on/dev/sgx/enclave.

Why _does_ the memory have to be shared? Shared mmap() is
fundamentally less secure than private mmap, since by definition it
means "oh, somebody else has access to it too and might modify it
under us".

Why does the SGX logic care about things like that? Normal executables
are just private mappings of an underlying file, I'm not sure why the
SGX interface has to have that shared thing, and why the interface has
to have a device node in the first place when  you have system calls
for setup anyway.

So why don't the system calls just work on perfectly normal anonymous
mmap's? Why a device node, and why must it be shared to begin with?

                  Linus
