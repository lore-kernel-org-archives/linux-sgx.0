Return-Path: <SRS0=Tkjg=R4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBF5C43381
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Mar 2019 23:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1630D20848
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Mar 2019 23:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553558384;
	bh=TVII3rwLPxMQCkQz9YIzhltAnZfhHgzWpvndRcBUX3Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Od7yy3+a4ed7L4/47hA8+Pw4ZilvVo11uHyGE7YSDMIwOpUXnYllFbQuNIxeH8KzT
	 7aO09v/8ckKQHT8vqyLMagQgWhENqMZj67hDSYvQy6HcvbmZCX7xlvnFGlnLzR7s9p
	 JozCwKSqzGqq7zSmpcJ/rCjW8fGDeqbJHpCIZxZA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfCYX7n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfCYX7n (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 Mar 2019 19:59:43 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6244320870
        for <linux-sgx@vger.kernel.org>; Mon, 25 Mar 2019 23:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553558382;
        bh=TVII3rwLPxMQCkQz9YIzhltAnZfhHgzWpvndRcBUX3Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0BUtZ0joQecupW3OQMSidOBY4iXPi+29GSpNeCrEL7egFlN3uWt/YmKIaefJW1KFB
         Apz4xGIpSpjZgz7PGvSltwfCDS/pGisBt7Pyce681b6TgaCyaqFqCZloMYSTZ7QoGs
         9fYPfxmTg3xrrSUyn5vPdbqgxXKWoAnL1mRTUD4Y=
Received: by mail-wr1-f46.google.com with SMTP id s15so12200851wra.12
        for <linux-sgx@vger.kernel.org>; Mon, 25 Mar 2019 16:59:42 -0700 (PDT)
X-Gm-Message-State: APjAAAWGNgyeN14N2uBNdJ47P5ci7IkrRMwbC18pUTAygkc4A7a6tn6n
        OJ5XqIBaDpLhRHGJwtUL80CWIJ5/Qst4wTqP21nzzQ==
X-Google-Smtp-Source: APXvYqyFb7ZjVtlwMJ8F32UgLL4W/OvBrrFZhjWLQnSdeU6UG/xabI+jBNatwXlbEotsMisrp1fa/XGKIHCJBaMkVDs=
X-Received: by 2002:adf:9c8f:: with SMTP id d15mr16864724wre.309.1553558380939;
 Mon, 25 Mar 2019 16:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com> <20190325180349.GF31069@linux.intel.com>
In-Reply-To: <20190325180349.GF31069@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 25 Mar 2019 16:59:30 -0700
X-Gmail-Original-Message-ID: <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
Message-ID: <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 25, 2019 at 11:03 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sun, Mar 24, 2019 at 01:59:48AM -0700, Xing, Cedric wrote:
> > As said in my previous email, this vDSO API isn't even compliant to
> > x86_64 ABI and is absolutely NOT for average developers. Instead,
> > host/enclave communications are expected to be handled by SDKs and
> > those developers will be very aware of the limitations of their targeted
> > environments, and will need the freedom to deploy optimal solutions.

> I fully realize that the above approach saddles Cedric and the SDK team
> with the extra task of justifying the need for two vDSO interfaces, and
> likely reduces the probability of their proposal being accepted.  But, we
> don't *force* the SDK to be rewritten, and we gain a vDSO interface that
> many people want and is acceptable to the maintainers (unless I've
> horribly misread Andy's position).

I don't think you've horribly misread it.  I would like to keep the
stuff in the vDSO as minimal as possible.  If we need to add a fancier
interface down the line, then that's fine.
