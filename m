Return-Path: <SRS0=TXuC=OG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F25DC43441
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 17:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2649F2082F
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 17:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="hW0i1vwU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2649F2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732144AbeK1Eyb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Nov 2018 23:54:31 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45609 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732019AbeK1Eyb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 27 Nov 2018 23:54:31 -0500
Received: by mail-pf1-f195.google.com with SMTP id g62so8743691pfd.12
        for <linux-sgx@vger.kernel.org>; Tue, 27 Nov 2018 09:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FjEPeuDTsdYAOiyxauMSBTAn10p+ceWBu+lwCNn0SIM=;
        b=hW0i1vwUNt77K8T7jvjWIZMICrvFScql4kNtD32rMfygjfU/IJOimXFdveRqcEt5sl
         6N3rukKFtHprjpMr657n2HzokbZr8QaDMcdH+Npk6dMFHucIQsrKmnIw4UdfGH9LP6o2
         zX5OGraIBeEE/TNkL1Vw5bMVKS3d8og5qn5HQqbAL83vPwhNYSDSVIJZ1IIcoTASMw8R
         9sbnnV0bghCOr6HrY5xchAXaIQMazjQdQHkKRXWe9sSN25nEKRPEvgF8ahf3rzmGZAPG
         aQbS/UA24eHW70RvkemSb+1rFiaS51uWGHPYKOb+gNgFxLm53Ov2zLUBtlcfQ+iVTnX1
         K3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FjEPeuDTsdYAOiyxauMSBTAn10p+ceWBu+lwCNn0SIM=;
        b=Zs8jIVYs58d19DwUfAx3rHATiz9Teuf8VLjBn6qdCLkHwwTpducVVbYvjsWvcVPWNQ
         ZqE189Ah7ffd6gzK8WUYwu0HBtKB7UhDAetKcuw7j1+uE+HJc8wP+7Fy/wBQZkAXooGb
         5GYa+9xXKbRuE3nWZ+p4dH52GohrlohwvXKBObWGhESSLaKsc2i1pqmXmvQhBl34bDiT
         jB68jFd4d/BIK7dLBbvrqPtMhZbX0uYxiNLCoL/2xH1kUyO77cupwg3YnSOn5p7f0Msa
         U2XmMEGhksE1oFJ/PX9A9SgOIr10HJIxEp0txLDOpfqwJNLCYAbfo8eWXwtN3no8XdJg
         B48g==
X-Gm-Message-State: AGRZ1gIyIBLGzLpnaeKLsFa21ntxHNPYVJnxcd5CwYMtt8tPsDHLRqGn
        NVfDfTChUoKg1GreR+6Xmc6Y2Q==
X-Google-Smtp-Source: AFSGD/WH1fQ8xZDJ5jkh14AEbgr5S74X3K+41t97ya22qpdI+/NmcUVX2HD0tiwiprjBbu0uYjJxwQ==
X-Received: by 2002:a63:a112:: with SMTP id b18mr30258592pgf.440.1543341349908;
        Tue, 27 Nov 2018 09:55:49 -0800 (PST)
Received: from ?IPv6:2600:1010:b02c:1f41:9d9b:cc3f:d42b:6cdd? ([2600:1010:b02c:1f41:9d9b:cc3f:d42b:6cdd])
        by smtp.gmail.com with ESMTPSA id z14sm4913525pgv.47.2018.11.27.09.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 09:55:47 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <20181127164129.GB4170@linux.intel.com>
Date:   Tue, 27 Nov 2018 09:55:45 -0800
Cc:     "Dr. Greg" <greg@enjellic.com>, Andy Lutomirski <luto@kernel.org>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net>
References: <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181126215145.GC868@linux.intel.com> <20181126230436.GA6737@linux.intel.com> <20181127085533.GA12247@wind.enjellic.com> <20181127164129.GB4170@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Nov 27, 2018, at 8:41 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.=
com> wrote:
>=20
>> On Tue, Nov 27, 2018 at 02:55:33AM -0600, Dr. Greg wrote:
>> Since the thread has become a bit divergent I wanted to note that we
>> have offered a proposal for a general policy management framework
>> based on MRSIGNER values.  This framework is consistent with the SGX
>> security model, ie. cryptographic rather then DAC based policy
>> controls.  This framework also allows a much more flexible policy
>> implementation that doesn't result in combinatoric issues.
>>=20
>> Our framework also allows the preservation of the current ABI which
>> allows an EINITTOKEN to be passed in from userspace.  The framework
>> also supports the ability to specify that only a kernel based launch
>> enclave (LE) should be available if the platform owner or distribution
>> should desire to implement such a model.
>>=20
>> The policy management framework is straight forward.  Three linked
>> lists or their equivalent which are populated through /sysfs
>> pseudo-files or equivalent plumbing.  Each list is populated with
>> MRSIGNER values for signing keys that are allowed to initialize
>> enclaves under three separate conditions.
>>=20
>> 1.) General enclaves without special attribute bits.
>>=20
>> 2.) Enclaves with the SGX_FLAGS_PROVISION_KEY attribute set. - i.e.,
>> 'Provisioning Enclaves'.
>>=20
>> 3.) Enclaves with the SGX_FLAGS_LICENSE_KEY attribute set - i.e., 'Launch=

>> Enclaves'.
>>=20
>> An all-null MRSIGNER value serves as a 'sealing' value that locks a
>> list from any further modifications.
>>=20
>> This architecture allows platform policies to be specified and then
>> sealed at early boot by the root user.  At that point cryptographic
>> policy controls are in place rather then DAC based controls, the
>> latter of which have perpetual security liabilities in addition to the
>> useability constraints inherent in a DAC or device node model.
>>=20
>> We have developed an independent implementation of the PSW and
>> arguably have as much experience with issues surrounding how to
>> interact with the device driver as anyone.  We have spent a lot of
>> time thinking about these issues and the above framework provides the
>> most flexible architecture available.
>=20
> Sounds like a lot bloat and policy added to the kernel whereas with
> Andy's proposal you can implement logic to a daemon and provide only
> mechanism to do it.
>=20
>=20

Well, almost. We=E2=80=99d need SGX_IOC_FREEZE_MR{ENCLAVE,SIGNER} or similar=
.  Or maybe the daemon could handle the entire loading process.  But this ca=
n wait until after the main driver is upstream.

This does lead to a question: enclaves are kind-of-sort-of mapped into a giv=
en address space. What happens if you issue the various ioctls in the contex=
t of a different mm?  For that matter, can two processes mmap the same encla=
ve?=
