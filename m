Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B4FC2BA16
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 14:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3380E2082F
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 14:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="R77Ljzcs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgDCOfU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 10:35:20 -0400
Received: from sonic306-27.consmr.mail.ne1.yahoo.com ([66.163.189.89]:41721
        "EHLO sonic306-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403865AbgDCOfU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 3 Apr 2020 10:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1585924518; bh=2IAy0s6Ogeiy95zWtGLDWhRZrlQUf8RNyl8TfrtGX6I=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=R77LjzcsBLJhSSJm53hn1WLSYVHh4h3q3HTxGvbTzPWUUiKDZMUWyb+wig9Uh3zrbfksffdp16Y3V4FBG3oGOuJF1DsxFVHw7VezwewWJmxcDtkWo6Xdyj7ZlpL5ZHrj4lFdmZMzHV9xZ5I1RIYJXHp20JiDO0ZTw4t/45TilrgDkzUQzJZCTFtf4oyGliapsMVGxBuX+8Ld5MOkGrrwEsii7VIzC8sNDlFo/cF2iIaN2S/3302FPLRh7v9rI1EWBg81vZJ6oZsSfLfoYnGx7e83Ui5G9PoruTKpBz/qlYPfgPdBXVPoK2jXek9DB4VKyT6DK9/wdL2eXHRppjWGMg==
X-YMail-OSG: 4Orft34VM1kI1Jh1WjBC45vrzeeEeprnC3boLKoyZCwojfI_8L4o3sICAhuvkk.
 tJuTqNl_rRx8OumBzhbSPKY336dldHHOnCpnYSxdVCplFi7VoJBBW3JxQZo6oq5UNeg.E3ufQe_6
 yTMD4T.8r5uFe7WKXQ49bFWwvJSizlVaBb23ziH1Um1tcu7QbGxp9Ec2bZJrWBaQSfnthuZYYYcN
 wyriB3WQDV9Mw2F6WVjqwnC73TJWwYRf2_jRKRDXrD.gDbLkWch0VuUJILuEkh_OUch9T5daGIOJ
 HxT7QtyQssX4jxaFw1rrS8XaKgVfbVU2oMOW46xkbemIiUi18bNnoeg8.gXSRC8jJW2MN47ymQcu
 jGP3mMdfLeNdERg4Akn6d0x16rMt2Ftqodb8zhF3Yl7QvYNawo1h9oLJpoK06M9Eq1TKOG3nspJL
 BbwwJvCoMMr.rsNQLbmvJRzOJK9SyPIG0wac.VWJg.4rZNZZjexApgJGKjvCgdW9fvM54yh5vE_W
 bBgfxrGM_g.aopvbs0omQRZmP5BY6X.xrCw9pEI22RyFaGxUmyxLnun72nzjFdVmIkLsdO6UpkSc
 dZmJpHknuurWLSQcM7wi4E0AOqlN6NRfgQkTCWMvEsNENSiI7qiSbW.SXqtJAwFDoiaBmasQzl_q
 L6l5VGEy7JYBo9uptyFBsOzMhqWIvqPHeS.GIbFk_iGupxhBA6.m1arUTffbDDEY1SQbq5C8Zl8h
 NYjWmd7aT5evOm9ut9mBhogCly3lDefDZV9TxtvCZ1tm7xShu3yNuw6JKATrOjCEVTJP0wIUC5Or
 47aRC1oW3ioVxv1c0gLQxbH7Kn5HqpGR2QVtUQ2fFuC60_cFlGB.zqMoUlFEuP1ZL2JfummQdi5P
 nOsfsEYg20p7Ui4tjL6UpMH.LKVD0_pM_HnX7Klc3E_iTInv1rjHbphL4CUyJ2fVWdL5l_vEJeEp
 y9cE8UChO1HPUd5U627O.WWqM7Diel53vMCl4lDRpduk4iwWU8MbUBIJZQFKl6cQSdecneGaVsIw
 uHrAtJIxmphIC_5PZXGTjKKXMFqOG5wWWDIpGVKPmnuD8S17GUBmEtOhbkD348Xt7_4CaRjm.z6h
 0ZSbqPbnmbht_rnSE.ARswOpCKlODwxm2YkwIRfcH3xr7VRJQrTaDH.mr2nxeS7kyqicbXzSWdNh
 50YotS_O0ILM4J73eX2eB0M3kLi_YLjb_uI5R78ZMqMZfAnSGfCPnMxkBjSoJY8H2RmTzCINh9gp
 8tJTxDYg.6u38G10g9XGbXr6G6xCpRmId4P_rQM.aW.6OGTpLZe3wAaW4kFt5cqec0n1aWn.6RvG
 xbWZ_gHR7ebfP6a68_t5C_CMxZh.o7zsx9zP6ei_1eyh0NFd8NKI7yq6nkeXNQDjadz2AzJNWsuz
 eEk_2a5bOjYwRDjeZIyOzg2feK6jVRrm7WSVEK1O4Y04t.LcPNtY-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Fri, 3 Apr 2020 14:35:18 +0000
Received: by smtp412.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID a667f4896cb4a8a28adbcc4b9aac56c7;
          Fri, 03 Apr 2020 14:35:17 +0000 (UTC)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
 <20200401002443.GE4847@linux.intel.com>
 <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
 <20200403065621.GB25305@linux.intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <f8698536-074e-6562-05df-26145a4c43b9@schaufler-ca.com>
Date:   Fri, 3 Apr 2020 07:35:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403065621.GB25305@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.15585 hermes Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 4/2/2020 11:56 PM, Jarkko Sakkinen wrote:
> On Thu, Apr 02, 2020 at 02:41:39PM -0700, Andy Lutomirski wrote:
>> On Tue, Mar 31, 2020 at 5:24 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>> On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
>>>
>>> If EXECMEM is a sticking point, one way to dodge it would be to add a
>>> helper to allow SELinux to detect enclave files.  It'd be ugly, but simple.
>>> That doesn't solve the generic labeling issue though.  It also begs the
>>> question of why hacking SELinux but not do_mmap() would be acceptable.
>>>
>>> If you have any ideas for fixing the noexec issue without resorting to an
>>> anon inode, we're all ears.
>> Hmm.  Maybe teach udev to put /dev/sgx on a different fs and
>> bind-mount it?  Or make /dev/sgx be an actual filesystem?  Or just
>> mount /dev with exec enabled?
> I'm not forseeing how the last option could work out as it is distro's
> choice.
>
> Casey, do you think we could use securityfs for this or do you have some
> other recommendation? I'm just asking you because you've used securityfs
> a lot.

I don't know how well securityfs works when mounted in a container,
but otherwise it would seem like a viable option. On the other hand,
pseudo filesystems are pretty easy to write, so /sys/fs/sgxfs wouldn't
be a bad choice, either.

>
> /Jarkko
