Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1D1C282E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD4421736
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfDSVin (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 17:38:43 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:42560 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfDSVin (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 19 Apr 2019 17:38:43 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hHbDS-0001rd-5E; Fri, 19 Apr 2019 23:38:38 +0200
Date:   Fri, 19 Apr 2019 23:38:36 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jethro Beekman <jethro@fortanix.com>
cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg" <greg@enjellic.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
In-Reply-To: <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
Message-ID: <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190418171059.GA20819@wind.enjellic.com> <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com> <20190419141732.GA2269@wind.enjellic.com> <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com> <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de> <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com> <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de> <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net> <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net> <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-821550267-1555709918=:3174"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-821550267-1555709918=:3174
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 19 Apr 2019, Jethro Beekman wrote:
> On 2019-04-19 14:31, Andy Lutomirski wrote:
> > I do think we need to follow LSM rules.  But my bigger point is that
> > there are policies that don’t allow JIT at all. I think we should
> > arrange the SGX API so it’s still usable when such a policy is in
> > effect.

> I don't think we need to arrange that right now. This patch set needs to
> be merged after more than 2 years of development. I'd like to avoid

We merge stuff when it is ready and not when someone declares that it needs
to be merged.

> introducing any more big changes. Let's just do what I described to make
> LSM not broken, which is a minimal change to the current approach. We
> can adjust the API later to support the use case you describe.

You are working around LSM nothing else and that's just not going to fly.

Thanks,

	tglx

--8323329-821550267-1555709918=:3174--
