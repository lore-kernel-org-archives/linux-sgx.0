Return-Path: <SRS0=I8pg=B5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20246C433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 13:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C76208B3
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 13:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FB4REDJR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgHSNeV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Aug 2020 09:34:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28256 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728597AbgHSNeA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 19 Aug 2020 09:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597844038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1A3YVzHwJmiHNz1WhEQhMZMMatTxl2bdR9e5Zus2ktM=;
        b=FB4REDJRLTLSWsOhnrXL/eVmelpVfXKCTkc21NLtVpChBOjwMyarNJfGYnW6oOVo++eFMi
        /hq/+RtGvsaP8NaoiinmErr9fREV4inQPknJtb83O1TZfnOtHWFfDHJPkCs2cXnYxQplVy
        F/fAaAjNbDYcock6lhpEQ6El9NhCfHQ=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-QjAunj-aMS6O6mbdt8V1rw-1; Wed, 19 Aug 2020 09:33:57 -0400
X-MC-Unique: QjAunj-aMS6O6mbdt8V1rw-1
Received: by mail-oo1-f72.google.com with SMTP id z2so11455547ooi.18
        for <linux-sgx@vger.kernel.org>; Wed, 19 Aug 2020 06:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1A3YVzHwJmiHNz1WhEQhMZMMatTxl2bdR9e5Zus2ktM=;
        b=YxT5jxgmZBOeo0NQZLuXyrZ72nrUP5N05uP90FJR0/xbovGOskzxjNMbYOlNYby04H
         TEgK5KZTxk9RbJSJ1MhEiIBx8faJXqUbvcOUm7TeTJpK7FIBBLszz+89w5SN07tPVVG8
         4NynQO7XjPCZSZeYttrvxIknzuvFVhl3JlB3BDxsOT7Qi22XOtnj7LfAJ3arTSejNHoj
         89FskpT1oLJWZG5sygnaGhY89mA4r4hzns+FgvF3XNWLUYEsFiOxNX5SDyslcAnOJF1/
         C1hreznPxZ0rArMkXIOywFpniGmp9oBVlccYNieevixOZxWQJoHbdbZr9l4CHysEPYF0
         hUaQ==
X-Gm-Message-State: AOAM530SCDxwRD/lQkcnAf/xvCXH/n310Q3LGbnKZcxzBFBbxtjJr0xa
        cMXrunyYatDxxLi7bexav6okVyr38njLxGIY6o40J7kkQ3mXZ0sdlpN+d4OzY7zzE20b2gszw5j
        o1SVlDozAmb7tpkh1ZwgKCEct4xPMZtRtcARk
X-Received: by 2002:a9d:6e1:: with SMTP id 88mr18165961otx.178.1597844036069;
        Wed, 19 Aug 2020 06:33:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDK4ZmVu++rFkaYtt43Tpk3Yf8PlFZGZT7z4I0jOccmzf4KD2leJPmhiIIUxoTN+497qRQJkjMR8MX0o9jLYk=
X-Received: by 2002:a9d:6e1:: with SMTP id 88mr18165944otx.178.1597844035864;
 Wed, 19 Aug 2020 06:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com> <20200818145234.GC132200@linux.intel.com>
 <20200818150627.GD132200@linux.intel.com> <CAOASepNxu0YtSPjXynLaVgyt-S0uSad8HVrNgMNWf+Z7iamPvQ@mail.gmail.com>
 <20200818164353.GH137138@linux.intel.com>
In-Reply-To: <20200818164353.GH137138@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Wed, 19 Aug 2020 09:33:45 -0400
Message-ID: <CAOASepMABkAxMRY7fJr4bAqadYyVrhZkb0BmB8cTcXUL_VmwQw@mail.gmail.com>
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nmccallu@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 18, 2020 at 12:44 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Aug 18, 2020 at 11:15:32AM -0400, Nathaniel McCallum wrote:
> > That seems like overkill to me. I'm just asking for one additional mov
> > instruction. :)
>
> I started to consider eBPF since the complexity and constraints of the
> callback look like an overkill and without doubt will be a burden to
> maintain.

That feels to me like more complexity just to move the existing
complexity from one place to another.

